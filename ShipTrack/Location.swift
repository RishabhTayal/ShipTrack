//
//  Location.swift
//  ShipTrack
//
//  Created by Tayal, Rishabh on 2/25/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

class Location {

    var city: String?
    
    init(dictionary: Dictionary<String, AnyObject>) {
        city = dictionary["city"] as? String
    }
}
