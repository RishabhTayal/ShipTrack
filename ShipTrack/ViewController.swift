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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "rightBarButtonTapped:")
        self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(barButtonSystemItem: .Camera, target: self, action: "ocrButtonTapped:"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "create", style: .Plain, target: self, action: "createTapped:")
        getTrackingStatus()
    }
    
    func createTapped(sender: AnyObject) {
        let createLabelVC = CreateShippingViewController()
        navigationController?.pushViewController(createLabelVC, animated: true)
    }
    
    func ocrButtonTapped(sender: AnyObject) {
        let ocrVC = OCRViewController()
        navigationController?.pushViewController(ocrVC, animated: true)
    }
    
    func rightBarButtonTapped(sender: AnyObject) {
        let scannerVC = storyboard?.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
        navigationController?.pushViewController(scannerVC, animated: true)
    }
    
    func getTrackingStatus() {
        Alamofire.request(Method.GET, "https://api.goshippo.com/v1/tracks/fedex/782421360311").responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            print(response.result.value)
            if let value = response.result.value, trackingHistory = value["tracking_history"] {
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
        
        AppHelpers.geoDecodeLocation(statusObj.location!) { (result) -> Void in
            print(result)
        }
        
        return cell!
    }
}