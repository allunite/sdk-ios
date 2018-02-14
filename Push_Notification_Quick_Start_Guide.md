IOS Apple Push Notification (APN) - Quick Start Guide
===============================


#### 1. Registering for Push Notifications.

#### 1.1. Open XCode project. You need to create an App ID in your developer account that has the push notification entitlement enabled. Luckily, Xcode has a simple way to do this. Go to App Settings -> Capabilities and flip the switch for Push Notifications to On.

#### 1.2. Open XCode project and add to to info.plist:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...
    <key>UIBackgroundModes</key>
    <array>
        ...
        <string>remote-notification</string>
        ...
    </array>
    ...
</dict>
</plist>
```

#### 1.2. Open XCode swift project and implement AppDelegate:

```

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let alluniteSdk = AllUniteSdkManager.sharedInstance()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        alluniteSdk.enableDebugLog()
        alluniteSdk.initializeAllUniteSdk(withAccountId: yourConfig.getAccountId(), accountKey: yourConfig.getAccountKey(), launchOptions: launchOptions)

        self.registerDeviceInAPN(application)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Send token to server = \(token)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError with error: \(error)")
    }

    // Payload (silent): { "aps" : { "content-available" : 1, "sound" : "" }, "data" :{"allunite" : "RequestDeviceStatus"}}
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print("User and silence apple push notification: \(userInfo.description)")

        if let date = userInfo["data"] as? [AnyHashable : Any],
        let allunite = date["allunite"] as? String, allunite == "RequestDeviceStatus"  {

            alluniteSdk.trackDeviceStatus({ (error: Error?) in
                if let e = error {
                    completionHandler(UIBackgroundFetchResult.failed)
                    print("trackDeviceStatus failed. Reason: \(e.localizedDescription)")
                    return
                }
                completionHandler(UIBackgroundFetchResult.noData)
            })
            return
        }

        completionHandler(UIBackgroundFetchResult.noData)
    }

    func registerDeviceInAPN(_ application: UIApplication){
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
    }
}
```

#### 1.2. Open Unity project and implement (demo) 

```
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;
using NotificationServices = UnityEngine.iOS.NotificationServices;
using NotificationType = UnityEngine.iOS.NotificationType;
using Device = UnityEngine.iOS.Device;

public class AlluniteSdk : MonoBehaviour {

	#if UNITY_IPHONE

	[DllImport("__Internal")]
	public static extern int AllUnite_enableDebugLog();

	[DllImport("__Internal")]
	public static extern int AllUnite_InitSDK(string accountId, string accountKey);
	[DllImport("__Internal")]
	private static extern void AllUnite_InitSDK_Async(string accountId, string accountKey, Callback callback);
	[DllImport("__Internal")]
	public static extern void AllUnite_Track(string actionCategory, string actionId);
	[DllImport("__Internal")]
	public static extern void AllUnite_TrackDeviceState();
		
	[DllImport("__Internal")]
	public static extern bool AllUnite_isBeaconTracking();
	[DllImport("__Internal")]
	public static extern void AllUnite_SendBeaconTrack();
	[DllImport("__Internal")]
	public static extern void AllUnite_StopBeaconTrack();

	[DllImport("__Internal")]
	public static extern bool AllUnite_isDeviceBounded();
	[DllImport("__Internal")]
	public static extern void AllUnite_BindDevice();
	[DllImport("__Internal")]
	public static extern void AllUnite_BindFbProfile(string profileToken, string profileData);
	[DllImport("__Internal")]
	public static extern void AllUnite_RequestAlwaysAuthorization();


	public delegate void Callback(int error);

	#endif

	private static string YOUR_ACCOUNT_ID = "UnityDemo";
	private static string YOUR_ACCOUNT_KEY = "2414863EEE4C41EAAE505983A9F2CD23";

	public void onClickInitSdkAsync(){
		Debug.Log("AllUnite_InitSDK_Async");

		AllUnite_enableDebugLog();

		AllUnite_InitSDK_Async (YOUR_ACCOUNT_ID, YOUR_ACCOUNT_KEY, asyncInitResult);
	}

	[MonoPInvokeCallback(typeof(Callback))]
	private static void asyncInitResult(int res) {
		Debug.Log("Init result: " + res);
		if (res == 0) {
			Debug.Log ("Init SDK. Success");
		} else {
			Debug.Log ("Init SDK. Failed network request");
		}
	}

	public void onClickRequestAutorizationStatus() {
		AllUnite_RequestAlwaysAuthorization();
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using NotificationServices = UnityEngine.iOS.NotificationServices;
using NotificationType = UnityEngine.iOS.NotificationType;
using Device = UnityEngine.iOS.Device;
using RemoteNotification = UnityEngine.iOS.RemoteNotification;

public class AllUniteSdkPushNotificationDemo : MonoBehaviour {

	private bool tokenSent = false;

	private string apnToken;
	private string deviceId;

	void Start () {
		this.registerRemoteNotifications ();
	}

	void Update () {
		this.sendApnToken ();
		this.handleRemoteNotifications();
	}


	private void registerRemoteNotifications(){
		NotificationServices.RegisterForNotifications(
			NotificationType.Alert | 
			NotificationType.Badge | 
			NotificationType.Sound);
	}


	private void sendApnToken(){
		if (tokenSent) {
			return;
		}

		byte[] token = NotificationServices.deviceToken;
		if (token == null) {
			return;
		}
		this.apnToken = System.BitConverter.ToString(token).Replace("-", "");
		this.deviceId = Device.vendorIdentifier;
		this.tokenSent = true;

		Debug.Log ("Send apn token = " + apnToken + " for device " + deviceId);
	}

	private void handleRemoteNotifications(){

		if (NotificationServices.remoteNotificationCount == 0) {
			return;
		}

		foreach (RemoteNotification notification in NotificationServices.remoteNotifications) {
			Debug.Log ("Received remote notification");
			this.handleRemoteNotification (notification);
		}

		NotificationServices.ClearRemoteNotifications();
	}

	// Payload (silent): { "aps" : { "content-available" : 1, "sound" : "" }, "data" :{"allunite" : "RequestDeviceStatus"}}
	private void handleRemoteNotification(RemoteNotification remoteNotification) {
		if (!isAllUniteRequest (remoteNotification)) {
			Debug.Log ("Handle your remote push notification");
			return;
		}

		string allUniteRequest = this.getAllUniteRequest (remoteNotification);
		if (allUniteRequest == "RequestDeviceStatus") {
			Debug.Log ("AllUniteSdk. remote notification - " + allUniteRequest );
			AlluniteSdk.AllUnite_TrackDeviceState ();
		} else {
			Debug.Log ("AllUniteSdk. remote notification - unknown " + allUniteRequest);
		}

	}

	private bool isAllUniteRequest(RemoteNotification remoteNotification){
		return this.getAllUniteRequest (remoteNotification) != null;
	}

	private string getAllUniteRequest(RemoteNotification remoteNotification){
		IDictionary data = remoteNotification.userInfo ["data"] as IDictionary;
		if (data == null) {
			return null;
		}
		return data ["allunite"] as string;
	}
}


```

Sending a Push Notification:
* in your developer account create the APN certificate (develop and/or distribution) 
* download the "APNS Push" app from the "App Store" to your Mac Os (free push notification test server)
* get a device token from ios device (launch app and get it from debug logs didRegisterForRemoteNotificationsWithDeviceToken)

Launch "APNS Push". Goto advanced mode. 
* select your APN certificate from drop down list (The app will automatically check for push certificates in the Keychain, and list them in a dropdown)
* add your device token to devices 
* change to silent payload: 
```{ "aps" : { "content-available" : 1, "sound" : "" }, "data" :{"allunite" : "RequestDeviceStatus"}}``` 
* press Push button
