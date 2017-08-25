//
//  YouSeeNavigationController.swift
//  AllUniteSdk
//
//  Created by Yury on 20.04.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit

class YouSeeNavigationController: UINavigationController {

    static weak var currentNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YouSeeNavigationController.currentNavController = self
    }
    
    class func openUrl(_ url:URL) -> (Bool){
        let urlMain = URL(string: "allunite-sdk-demo://main")
        if url == urlMain {
            
            AllUniteSdkManager.sharedInstance().reinitilize({ (error) in
                if let _ = error {
                    print("Reinitilize after bind failed")
                }
                
                if let navigationController = currentNavController {
                    navigationController.pushViewController(YouSeeNavigationController.newApplicationVC(), animated: true)
                }
            })
            
            return true
        }
        return false
    }
    
    class func newMainNC() -> UINavigationController {
        let controller = storyboard().instantiateViewController(withIdentifier: "youSeeNC")
        return controller as! UINavigationController
    }
    
    class func newLoginVC() -> YouSeeLoginViewController {
        
        let controller = storyboard().instantiateViewController(withIdentifier: "youSeeLoginVC")
        return controller as! YouSeeLoginViewController
    }
    
    class func newTermsAndConditionVC() -> YouSeeTermsAndCondViewController {
        
        let controller = storyboard().instantiateViewController(withIdentifier: "youSeeTermsAndCondVC")
        return controller as! YouSeeTermsAndCondViewController
    }
    
    class func newApplicationVC() -> YouSeeAppViewController {
        
        let controller = storyboard().instantiateViewController(withIdentifier: "youSeeAppVC")
        return controller as! YouSeeAppViewController
    }
    
    fileprivate class func storyboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "yousee", bundle: nil)
        return storyboard
    }

}
