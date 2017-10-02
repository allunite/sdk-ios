
import UIKit

class YouViewController: UIViewController {
    
    let alluniteSdk = AllUniteSdkManager.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindAndTrackDevice()
    }
    
    
    func detectStateSdk(){
        let enabled:Bool = alluniteSdk.isSdkEnabled()
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

