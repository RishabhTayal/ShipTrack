//
//  ViewController.swift
//  ShipTrack
//
//  Created by Tayal, Rishabh on 2/25/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var datasource: [TrackingStatus] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTrackingStatus()
    }

    func getTrackingStatus() {
        Alamofire.request(Method.GET, "https://api.goshippo.com/v1/tracks/fedex/782421360311").responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            print(response.result.value)
            if let trackingHistory = response.result.value!["tracking_history"] {
                self.datasource = []
                for status in trackingHistory as! [Dictionary<String, AnyObject>] {
                    let statusObj = TrackingStatus.init(dictionary: status)
                    self.datasource.append(statusObj)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let statusObj = datasource[indexPath.row]
        cell?.textLabel?.text = statusObj.status
        cell?.detailTextLabel?.text = statusObj.location?.city
        return cell!
    }
}