//
//  ViewController.swift
//  playground
//
//  Created by Yury on 27.03.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit
import AdSupport

import CoreLocation

class PlaygroundController: UIViewController {
    static let TAG = String(describing: PlaygroundController.self)
    
    let alluniteSdk = AllUniteSdkManager.sharedInstance()
    
    @IBOutlet weak var bindDeviceButton: UIButton!
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var startTrackingBeaconsButton: UIButton!
    @IBOutlet weak var bindFacebook: UIButton!
    
    @IBOutlet weak var sdkStateButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initilizeViewController()
    }
    
    @IBAction func demoButtonClicked(_ sender: Any) {
        let demoViewController = YouViewController()
        self.navigationController?.show(demoViewController, sender: self)
    }
    
    @IBAction func sdkStateButtonClicked(_ sender: Any) {
        alluniteSdk.setSdkEnabled(!alluniteSdk.isSdkEnabled())
        self.updateSdkStateButton()
    }
    
    @IBAction func openYouSeeDemo(_ sender: Any) {
        self.present(YouSeeNavigationController.newMainNC(), animated: true)
    }
    
    func bindAndTrackDevice() {
        
        alluniteSdk.requestAutorizationStatus { (status: CLAuthorizationStatus) in
            if status != CLAuthorizationStatus.authorizedWhenInUse
                && status != CLAuthorizationStatus.authorizedAlways {
                print("app don't have permission using CoreLocation")
                return
            }
            
            self.alluniteSdk.reinitilize({ (error) in
                if let err = error {
                    print("Failed. Reason: \(err.localizedDescription)")
                    return
                }
                
                self.alluniteSdk.startTrackingBeacon({ (error) in
                    if let _ = error {
                        print("failed")
                        return
                    }
                    print("success")
                    self.updateStateTrackingOnViewControllerIfNeed()
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
    
    @IBAction func bindDevice(_ sender: Any) {
        bindAndTrackDevice()
    }
    
    @IBAction func bindFacebookProfile(_ sender: Any) {
        
        guard let token = Facebook.token() else {
            self.showMessage(message: "Need login to facebook")
            return
        }
        
        Facebook.getProfileData(profileToken: token) { error, result in
            if let _ = error {
                self.showMessage(message: "Facebook request failed.")
                return
            }
            
            let profileJsonData = PlaygroundController.toJsonString(map: result) ?? "{}"
            
            self.alluniteSdk.bindFacebook(token, profileJson: profileJsonData) { (error) in
                if let error = error {
                    print("\(PlaygroundController.TAG). Bind facebook failed. Reason: \(error.localizedDescription)")
                    return
                }
                print("\(PlaygroundController.TAG). Bind facebook completed")
            }
        }
    }
    
    @IBAction func unbindDevice(_ sender: Any) {
        let deviceId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        
        let shaData = sha256(string: deviceId)
        let shaDeviceId = shaData!.map { String(format: "%02hhx", $0) }.joined()
        
        let url = URL(string:"https://sdk-api.allunite.com/bind/machash/\(shaDeviceId)")!;
        Alamofire.request(url, method: HTTPMethod.delete).response { (responce) in
            
            if let error = responce.error {
                self.showMessage(message: "Unbind device failed. Reason: \(error.localizedDescription)")
                return
            }
            
            self.alluniteSdk.reinitilize({ (error) in
                if let _ = error {
                    self.showMessage(message: "Unbind succes but init Sdk request failed")
                    return
                }
                
                if !self.alluniteSdk.isDeviceBounded() {
                    self.showMessage(message: "Device matching is revoked")
                }
            })
        }
        
    }
    
    @IBAction func sendTrack(_ sender: Any) {
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
    
    @IBAction func startBeaconTracking(_ sender: Any) {
        
        if alluniteSdk.isTrackingBeacons() {
            //setTrackingState(started: false)
            alluniteSdk.stopTrackingBeacon()
            updateTrackingButton()
            return
        }
        
        alluniteSdk.startTrackingBeacon({ (error) in
            if let error = error {
                print("\(PlaygroundController.TAG). Start track beacon failed. Reason: \(error.localizedDescription)")
                self.updateTrackingButton()
                return
            }
            print("\(PlaygroundController.TAG). Send track beacon completed")
            self.updateTrackingButton()
        }) { (beaconinfo) in
            print("\(PlaygroundController.TAG). Beacon detected completed")
        }
    }
    
    func updateTrackingButton() {
        if alluniteSdk.isTrackingBeacons() {
            startTrackingBeaconsButton.setTitle("Stop beacon track", for: UIControlState.normal)
        } else {
            startTrackingBeaconsButton.setTitle("Start beacon track", for: UIControlState.normal)
        }
    }
    
    func sha256(string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
}

extension PlaygroundController {
    
    fileprivate func initilizeViewController(){
        self.initilizeFacebookButton()
        self.updateTrackingButton()
        self.updateSdkStateButton()
    }
    
    fileprivate func updateStateTrackingOnViewControllerIfNeed() {
        self.updateTrackingButton()
    }
    
    fileprivate func updateSdkStateButton(){
        let buttonTitle = alluniteSdk.isSdkEnabled() ? "sdkEnabled = true": "sdkEnabled = false"
        sdkStateButton.setTitle(buttonTitle, for: UIControlState.normal)
    }
    
    fileprivate class func toJsonString(map: [String: Any]?) -> String? {
        let profileJsonData = try? JSONSerialization.data(withJSONObject: map ?? [:], options: [])
        
        return String(data: profileJsonData!, encoding: String.Encoding.utf8)
    }
    
    fileprivate func initilizeFacebookButton(){
        let button = Facebook.newLoginButton();
        button.frame = CGRect(x: 0, y: 0, width: facebookLoginButton.frame.size.width, height: facebookLoginButton.frame.size.height)
        facebookLoginButton.addSubview(button)
    }
}

extension UIViewController {
    
    func showMessage(message: String, title: String? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

