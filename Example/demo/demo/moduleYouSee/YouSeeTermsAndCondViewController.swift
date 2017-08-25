//
//  YouSeeTermsAndCondViewController.swift
//  AllUniteSdk
//
//  Created by Yury on 19.04.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit

class YouSeeTermsAndCondViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var termsAndCond: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    var acceptButtonStoryboardBackgroundColor: UIColor?
    
    let allIniteSdk = AllUniteSdkManager.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilizeNavigationBar();
        initilizeTermsAndCondTextView()
        initilizeAcceptButton()
        initilizeCancelButton()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAcceptButton()
    }
    
    @IBAction func acceptButtonClicked(_ sender: Any) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        allIniteSdk.bindDevice { (error) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            if let error = error {
                self.showMessage(message: "Bind device failed. reason: \(error.localizedDescription)")
                return
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        updateAcceptButton()
    }
}

// MARK: private
extension YouSeeTermsAndCondViewController {

    fileprivate func updateAcceptButton(){
        if termsAndCond.isAtBottom {
            acceptButton.isEnabled = true
            acceptButton.backgroundColor = acceptButtonStoryboardBackgroundColor
        } else {
            acceptButton.isEnabled = false
            acceptButton.backgroundColor = UIColor.white
        }
    }
    
    fileprivate func initilizeTermsAndCondTextView(){
        
        termsAndCond.setContentOffset(CGPoint(x:0, y:0), animated: false)
        
        if let termsAndCondText = termsAndCond.attributedText.mutableCopy() as? NSMutableAttributedString {
            let _ = termsAndCondText.setAsLink(textToFind:"her", linkURL:"https://yousee.dk/om_yousee/om_youseedk/cookies_paa_youseedk.aspx")
            termsAndCond.attributedText = termsAndCondText
        }
    }
    
    fileprivate func initilizeAcceptButton(){
        acceptButtonStoryboardBackgroundColor = acceptButton.backgroundColor
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = UIColor.white
        
        acceptButton.backgroundColor = .clear
        acceptButton.layer.cornerRadius = 5
        acceptButton.layer.borderWidth = 1
        acceptButton.layer.borderColor = acceptButtonStoryboardBackgroundColor?.cgColor
    }
    
    fileprivate func initilizeCancelButton(){
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = acceptButtonStoryboardBackgroundColor?.cgColor
    }
    
    fileprivate func initilizeNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
}

// MARK: extensions
extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of:textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}

extension UIScrollView {
    
    var isScrollContentLessScrollView: Bool {
        return contentSize.height < frame.size.height
    }
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        
        let bottomEdge = contentOffset.y + frame.size.height
        return bottomEdge >= contentSize.height
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}
