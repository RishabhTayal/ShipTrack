//
//  TrackingStatus.swift
//  ShipTrack
//
//  Created by Tayal, Rishabh on 2/25/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

class TrackingStatus {
    
    var location: Location?
    var status: String?
    
    init(dictionary: Dictionary<String, AnyObject>) {
        status = dictionary["status"] as? String
        location = Location(dictionary: dictionary["location"] as! Dictionary<String, AnyObject>)
    }
}