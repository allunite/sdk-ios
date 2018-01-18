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

#### 1.2. Open XCode project and implement AppDelegate:

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
