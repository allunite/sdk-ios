//
//  Facebook.swift
//  AllUniteSdk
//
//  Created by Yury on 28.03.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class Facebook: NSObject {
    
    class func configure(){
        SDKSettings.appId = Config.sharedInstance.facebookAppId()
        SDKSettings.displayName = Config.sharedInstance.facebookAppDisplayName()
    }
    
    class func applicationDidBecomeActive(){
        AppEventsLogger.activate()
    }
    
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Facebook.self.configure()
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true;
    }
    
    class public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    
    class func isUserLoggined() -> Bool {
        if let _ = AccessToken.current {
            return true
        }
        return false
    }
    
    class func token() -> String? {
        return AccessToken.current?.authenticationToken
    }
    
    
    class func newLoginButton() -> LoginButton {
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        return loginButton
    }
    
    class func getProfileData(profileToken: String, completion: @escaping (_ error: NSError?, _ result: [String : Any]?) -> ()) {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields" : "id, email, birthday, first_name, gender, last_name, link, location, name, locale, timezone, updated_time, verified"])
        graphRequest.start { (httpResponce, result) in
            
            switch result {
            case .failed(let error):
                print("error in graph request:", error)
                completion(error as NSError?, nil)
                return
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    completion(nil, responseDictionary)
                    return
                }
                completion(nil, nil)
                return
            }
        }
    }
    
    
}
