import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let alluniteSdk = AllUniteSdkManager.sharedInstance()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let accountId = "Ardas test" //"YOUR_ACCOUNT_ID"
        let accountKey = "287708C2BE7048A3B4D8518D84E642B3" //"YOUR_ACCOUNT_KEY"
        
        alluniteSdk.initializeAllUniteSdk(withAccountId: accountId, accountKey: accountKey, launchOptions: launchOptions)
        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (alluniteSdk.open(url, options: options)){
            return true;
        }
        
        return false
    }

}

