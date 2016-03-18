//
//  AppHelpers.swift
//  ShipTrack
//
//  Created by Tayal, Rishabh on 2/25/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit
import CoreLocation

class AppHelpers: NSObject {
    
    static let ShippoPrivateAuthToken = "ec9bd4e1035a8a574de89c5c98f22cc8ea4b6525"
    
    class func geoDecodeLocation(locationObj: Location, completion: ((result: CLPlacemark?) -> Void)) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationObj.city!) { (placemark: [CLPlacemark]?, error: NSError?) -> Void in
            if let placemark = placemark {
                completion(result: (placemark.first)!)
            } else {
                completion(result: nil)
            }
        }
    }
}
