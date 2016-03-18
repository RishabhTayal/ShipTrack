//
//  CreateShippingViewController.swift
//  ShipTrack
//
//  Created by Tayal, Rishabh on 3/18/16.
//  Copyright © 2016 Tayal, Rishabh. All rights reserved.
//

import UIKit
import Alamofire

class CreateShippingViewController: UIViewController {
    
    var tableView: UITableView!
    
    var dataArray: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteColor()
        
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        createShippingObject()
        // Do any additional setup after loading the view.
    }
    
    func createShippingObject() {
        let headers = ["Authorization": "ShippoToken " + AppHelpers.ShippoPrivateAuthToken, "Content-Type": "application/json"] as [String: String]
        let params = ["object_purpose":"PURCHASE",
            "address_from": [
                "object_purpose":"PURCHASE",
                "name":"Mr. Hippo",
                "company":"Shippo",
                "street1":"215 Clayton St.",
                "street2":"",
                "city":"San Francisco",
                "state":"CA",
                "zip":"94117",
                "country":"US",
                "phone":"+1 555 341 9393",
                "email":"support@goshippo.com"
            ],
            "address_to":[
                "object_purpose":"PURCHASE",
                "name":"Mrs. Hippo",
                "company":"Shippo",
                "street1":"Mission St.",
                "street_no":"814",
                "street2":"",
                "city":"San Francisco",
                "state":"CA",
                "zip":"94105",
                "country":"US",
                "phone":"+1 555 341 9393",
                "email":"support@goshippo.com",
                "metadata":"Customer ID 123456"
            ],
            "parcel":[
                "length":"5",
                "width":"5",
                "height":"5",
                "distance_unit":"in",
                "weight":"2",
                "mass_unit":"lb",
                "template":"",
                "metadata":"Customer ID 123456"
            ],
            "reference_1":"Created on",
            "reference_2":"Shippo",
            "metadata":"Customer ID 123456",
            "async": false] as [String: AnyObject]
        
        Alamofire.request(.POST, "https://api.goshippo.com/v1/shipments/", parameters: params, encoding: Alamofire.ParameterEncoding.JSON, headers: headers).responseJSON { (response: Response<AnyObject, NSError>) -> Void in
            print(response.result.value)
            self.dataArray = response.result.value!["rates_list"] as! [AnyObject]
            self.tableView.reloadData()
        }
    }
}

extension CreateShippingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        let rate = dataArray[indexPath.row]
        cell?.textLabel?.text = rate["duration_terms"] as? String
        return cell!
    }
}

