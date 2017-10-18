import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let alluniteSdk = AllUniteSdkManager.sharedInstance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let accountId = "PodTest" //"YOUR_ACCOUNT_ID"
        let accountKey = "E539308C3D164BA286CB0398D03F16B2" //"YOUR_ACCOUNT_KEY"
        
        alluniteSdk.initializeAllUniteSdk(withAccountId: accountId, accountKey: accountKey, launchOptions: launchOptions)
        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (alluniteSdk.open(url, options: options)){
            return true;
        }
        
        return false
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Background fetch")
        alluniteSdk.backgroundFetch {
            print("Background fetch completed")
            completionHandler(UIBackgroundFetchResult.noData)
        }
    }

}

