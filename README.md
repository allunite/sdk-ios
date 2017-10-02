IOS native SDK - Quick Start Guide
===============================

#### 1. To use AllUniteSdk you need to add dependencies to your XCode project.

We recommend installing AlluniteSdk with CocoaPods. CocoaPods is an Objective-C library dependency manager. You can learn more about CocoaPods from [http://cocoapods.org](http://cocoapods.org/).

Add a dependency to your Podfile in your Xcode project directory:
```ruby
pod 'AlluniteSdk', :git => 'https://github.com/allunite/io-sdk.git', :tag => '1.2.11'
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
				<string>allunite-sdk</string>
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
		...
	</array>
	
	<key>NSBluetoothPeripheralUsageDescription</key>
	<string>Bluetooth Peripheral Usage Description</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>Description to user - location always usage</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>Description to user - location when in use</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    	<string>Application tracks your position to search nearby shops</string>
    	<key>NSLocationWhenInUseUsageDescription</key>
    	<string>Application tracks your position to search nearby shops</string>
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
}
```

#### 4. Now to call AllUniteSdk Api you can use AllUniteSdkManager

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
        
        alluniteSdk.requestAutorizationStatus { (status: CLAuthorizationStatus) in
            
            if status == CLAuthorizationStatus.notDetermined {
                self.alluniteSdk.requestAutorizationStatus()
                return
            }
            
            if     status != CLAuthorizationStatus.authorizedWhenInUse
                && status != CLAuthorizationStatus.authorizedAlways {
                
                if status == CLAuthorizationStatus.denied {
                    let alert = UIAlertController(title: "Alert", message: "User has explicitly denied authorization for this application, or location services are disabled in Settings.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                print("App don't have permission using Location Service")
                return
            }
            
            self.alluniteSdk.reinitilize({ (error) in
                if let err = error {
                    print("Reinitilize failed. Reason: \(err.localizedDescription)")
                    return
                }
                
                self.alluniteSdk.startTrackingBeacon({ (error) in
                    if let _ = error {
                        print("startTrackingBeacon failed")
                        return
                    }
                    print("startTrackingBeacon success")
                }) { (beaconinfo) in
                    print("Beacon detected")
                }
                
                self.alluniteSdk.bindDevice({ (error) in
                    if let _ = error {
                        print("bindDevice failed.")
                        return
                    }
                    print("bindDevice success")
                })
            })
        }
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
