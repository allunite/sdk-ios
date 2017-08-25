//
//  youSeeAppViewController.swift
//  AllUniteSdk
//
//  Created by Yury on 19.04.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit

class YouSeeAppViewController: UIViewController {

    @IBOutlet weak var appImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initilizeNavigationBar()
        initilizeImage()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func initilizeNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func initilizeImage(){
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(YouSeeAppViewController.imageClicked))
        singleTap.numberOfTapsRequired = 1
        appImage.isUserInteractionEnabled = true
        appImage.addGestureRecognizer(singleTap)
    }

    func imageClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
