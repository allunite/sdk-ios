//
//  YouSeeLoginViewController.swift
//  AllUniteSdk
//
//  Created by Yury on 19.04.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit
import AlluniteSdk

class YouSeeLoginViewController: UIViewController, UITextFieldDelegate {

    let allUniteSdk = AllUniteSdkManager.sharedInstance()
    
    @IBOutlet weak var youSeeLogo: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizetGradient()
        initilizeNavigationBar()
        initilizeLogoBackNavigation()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        let nextController = allUniteSdk.isDeviceBounded() ? YouSeeNavigationController.newApplicationVC() : YouSeeNavigationController.newTermsAndConditionVC()
        self.navigationController?.pushViewController(nextController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    fileprivate func initilizeLogoBackNavigation(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(YouSeeLoginViewController.imageClicked))
        singleTap.numberOfTapsRequired = 1
        youSeeLogo.isUserInteractionEnabled = true
        youSeeLogo.addGestureRecognizer(singleTap)
    }
    
    func imageClicked() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func initilizetGradient(){
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame.size = self.gradientView.frame.size
        gradient.colors = [ UIColor.black.cgColor, UIColor.green.cgColor, UIColor.green.cgColor, UIColor.black.cgColor]
        gradient.locations = [0, 0.3, 0.7, 1]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradientView.layer.addSublayer(gradient)
    }
    
    fileprivate func initilizeNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
}
