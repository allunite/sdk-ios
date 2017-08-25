//
//  AllUniteSdkLocationManager.swift
//  AllUniteSdk
//
//  Created by Yury on 24.07.17.
//  Copyright © 2017 AllUnite. All rights reserved.
//

import UIKit
import CoreLocation

class AllUniteSdkLocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var completion: ((_ status:CLAuthorizationStatus) -> ())?
    
    static let sharedInstance = AllUniteSdkLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Status changed")
        
        if let compl = self.completion {
            compl(status)
        }
    }
    
    func requestAutorizationStatus(_ completion: ((_ status:CLAuthorizationStatus) -> ())?){
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.completion = completion
        
        locationManager.requestAlwaysAuthorization()
    }
    
}
