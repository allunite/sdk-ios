IOS native SDK - Quick Start Guide
===============================

# What it is and why you need it?

AllUnite offers a technological platform to measure the effect of various marketing channels to visits in local stores. 
The measurement is done via anonymous consumers who have accepted permission.
AllUnite measure the anonymous consumer in the local store using AllUnite WiFi and iBeacon technology.

The purpose of this document is to describe how to integrate AllUnite SDK in an app.

AllUnite SDK designed to match consumer's web profile to their physical device and to track
consumers in the physical world.

![Overal schema](https://s3-eu-west-1.amazonaws.com/allunite-main/doc/scheme_v3.2.png)

How it works (workflow)
===============================

##### 1. Match physical device (**REQUIRED**)
To match the device we need to open web browser and do a few redirects to link consumer's cookies with device ID.
Finally consumer's journey ends on a landing page that tries to open Application at once or makes it possible to open Application later.

Method alluniteSdk.bindDevice() performs matching process described above.

##### 2. Request consumer's permission (**REQUIRED**)
Tracking technology requires location permission that should be requested from a consumer.
Call to alluniteSdk.requestAutorizationStatus() method shows the dialog if permission has not been requested already.
AllUnite SDK doesn't tracks the device in case location permission is not provided.

You can enable or disable SDK explicitly using application URI (deep link) [app_schema]://allunite-sdk-mode?enable=[true/false].
To make it possible you would need to override system application public function and call alluniteSdk.open() as it described in "Init AllUniteSdk in application delegate" below.

It can be useful if Application shows Terms & Conditions page that has "OK" and "No Thanks" options.
In this case "No Thanks" button opens [app_schema]://allunite-sdk-mode?enable=false that disables AllUnite SDK functionality, "OK" button can starts matching process directly in the browser (we need to customize it first) or using alluniteSdk.bindDevice() method (see previous paragraph).

Alternative way to switch SDK on/off is alluniteSdk.setSdkEnabled([true/false]) method.
Method alluniteSdk.isSdkEnabled() shows you current state.

##### 3. Start beacon tracking (**REQUIRED**)
To start tracking you need to call alluniteSdk.startTrackingBeacon() method.
AllUnite SDK will track device in foreground and background until alluniteSdk.stopTrackingBeacon() method is called.
You can specify a delegate in alluniteSdk.startTrackingBeacon() method that will be called each time when beacon detected.
It can be used to show a message or do any other actions when consumer enters an area of the beacon vicinity.

##### 4. Custom actions tracking (**OPTIONAL**)
You can register any custom actions using alluniteSdk.track() method and use it next to location tracking info on the AllUnite Campaign Dashboard.


IOS native SDK - Quick Start Guide
===============================

#### 1. To use AllUniteSdk you need to add dependencies to your XCode project.

We recommend installing AlluniteSdk with CocoaPods. CocoaPods is an Objective-C library dependency manager. You can learn more about CocoaPods from [http://cocoapods.org](http://cocoapods.org/).

Add a dependency to your Podfile in your Xcode project directory:
```ruby
pod 'AlluniteSdk', :git => 'https://github.com/allunite/sdk-ios.git', :tag => '1.2.21'
```

Now you can install the AlluniteSdk dependency in your project:

```
$ pod install
```
If you need to update the installed AlluniteSdk dependency in your project:

```
$ pod update
```

To import AllUniteSdk into a Swift project, add `#import "AllUniteSdkManager.h"` into your bridging header.

#### 2. Add to info.plist:

Custom Url scheme:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
...
	<key>CFBundleURLTypes</key>
	<array>
		...
		<dict>
			<key>CFBundleURLName</key>
			<string>AllUniteSdk</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>your_allunite_unique_sheme</string>
			</array>
		</dict>
		...
	</array>
...
</dict>
</plist>

```
For location and beacon tracking add this to info.plist :
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
...
	<key>UIBackgroundModes</key>
	<array>
		...
		<string>bluetooth-central</string>
		<string>fetch</string>
		...
	</array>
	
	<key>NSBluetoothPeripheralUsageDescription</key>
	<string>Bluetooth Peripheral Usage Description</string>
	<key>NSLocationUsageDescription</key>
	<string>Description to user - location usage</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>Description to user - location always usage</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>Description to user - location when in use</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>Description to user - location always and when in use</string>
...
</dict>
</plist>
```

#### 3. Init AllUniteSdk in application delegate

```
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let alluniteSdk = AllUniteSdkManager.sharedInstance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        let accountId = YOUR_ACCOUNT_ID;
        let accountKey = YOUR_ACCOUNT_KEY;
        alluniteSdk.initializeAllUniteSdk(withAccountId: accountId, accountKey: accountKey, launchOptions: launchOptions)
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (alluniteSdk.open(url, options: options)){
            return true;
        }
        // handle your url
        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Background fetch
        alluniteSdk.backgroundFetch {
            // Background fetch completed
            completionHandler(UIBackgroundFetchResult.noData)
        }
        
	// yours background fetch
    }
}
```

#### 4. You can call AllUniteSdk API using AllUniteSdkManager

```
class YouViewController: UIViewController {
    
    let alluniteSdk = AllUniteSdkManager.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAndTrackDevice()
    }
    
    
    func detectStateSdk(){
        let enabled:Bool = alluniteSdk.isSdkEnabled()
        print("SdkDisabled \(enabled)");
        if(enabled){
            print("All api functions are available")
        } else {
            print("Only func initializeAllUniteSdk is enabled")
        }
    }
    
    func changeStateSdk(){
        print("You can enable sdk for current device")
        alluniteSdk.setSdkEnabled(true)
        
        print("You can disable sdk for current device")
        alluniteSdk.setSdkEnabled(false)
    }
    
    func bindAndTrackDevice() {
        
        alluniteSdk.reinitilize({ [weak self, sdk = self.alluniteSdk] (error) in
            if let err = error {
                print("Failed. Reason: \(err.localizedDescription)")
                return
            }
            
            sdk.bindDevice({ (error) in
                if let _ = error {
                    print("bindDevice failed.")
                    return
                }
                print("bindDevice success")
            })
            
            sdk.requestAutorizationStatus(AllUniteSdkAuthorizationAlgorithm.always) { (status: CLAuthorizationStatus) in
                if status == CLAuthorizationStatus.notDetermined {
                    //sdk.requestAutorizationStatus()
                    return
                }
                
                if     status != CLAuthorizationStatus.authorizedWhenInUse
                    && status != CLAuthorizationStatus.authorizedAlways {
                    
                    if (status == CLAuthorizationStatus.denied) {
                        let alert = UIAlertController(title: "Alert", message: "User has explicitly denied authorization for this application, or location services are disabled in Settings.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    print("app don't have permission using Location Service")
                    return
                }
                
                sdk.startTrackingBeacon({ (error) in
                    if let _ = error {
                        print("startTrackingBeacon failed")
                        return
                    }
                    print("startTrackingBeacon success")
                }) { (beaconinfo) in
                    print("Beacon detected")
                }
            }
        })
    }
    
    func bindFacebookProfile() {
        
        let token = getFacebookToken()
        let profileJsonData = getFacebookProfileJson()
        
        alluniteSdk.bindFacebook(token, profileJson: profileJsonData) { (error) in
            if let _ = error {
                print("fail")
                return
            }
            print("success")
        }
    }
    
    func sendCampaignTrack() {
        
        let actionCategory = "showCampaign";
        let actionId = "blackFriday2016";
        alluniteSdk.track(withCategory: actionCategory, actionId: actionId) { (error) in
            if let _ = error {
                print("fail")
                return
            }
            print("success")
        }
    }
    
    
    func getFacebookToken() -> String {
        return "facebook user token"
    }
    
    func getFacebookProfileJson() -> String {
        return "facebook profile json for user token"
    }

}
```
