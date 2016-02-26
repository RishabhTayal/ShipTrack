//
//  MTBViewController.m
//  MTBBarcodeScannerExample
//
//  Created by Mike Buss on 2/8/14.
//
//

import MTBBarcodeScanner

class ScannerViewController: UIViewController {
    
    @IBOutlet var previewView: UIView!
    @IBOutlet var toggleScanningButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toggleTorchButton: UIBarButtonItem!
    
    //    var scanner: MTBBarcodeScanner!
    var uniqueCodes: [AnyObject] = []
    var captureIsFrozen: Bool = false
    var didShowCaptureWarning: Bool!
    
    var scanner: MTBBarcodeScanner!
    
    //pragma mark - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = MTBBarcodeScanner(previewView: previewView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "previewTapped")
        self.previewView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.scanner.stopScanning()
        super.viewWillDisappear(animated)
    }
    
    //pragma mark - Scanning
    
    func startScanning() {
        self.uniqueCodes = [AnyObject]()
        self.scanner.startScanningWithResultBlock { (codes: [AnyObject]!) -> Void in
            for code in codes as! [AVMetadataMachineReadableCodeObject] {
                let index = self.uniqueCodes.indexOf({ (object: AnyObject) -> Bool in
                    return object as! String == code.stringValue
                })
                if (code.stringValue != nil) && (index == NSNotFound) {
                    self.uniqueCodes.append(code.stringValue)
                    NSLog("Found unique code: %@", code.stringValue)
                    // Update the tableview
                    self.tableView.reloadData()
                    self.scrollToLastTableViewCell()
                }
            }
        }
        self.toggleScanningButton.setTitle("Stop Scanning", forState: .Normal)
        self.toggleScanningButton.backgroundColor = UIColor.redColor()
    }
    
    func stopScanning() {
        self.scanner.stopScanning()
        self.toggleScanningButton.setTitle("Start Scanning", forState: .Normal)
        self.toggleScanningButton.backgroundColor = self.view.tintColor
        self.captureIsFrozen = false
    }
    
    //pragma mark - Actions
    
    @IBAction func toggleScanningTapped(sender: AnyObject) {
        if self.scanner.isScanning() || self.captureIsFrozen {
            self.stopScanning()
            self.toggleTorchButton.title = "Enable Torch"
        }
        else {
            MTBBarcodeScanner.requestCameraPermissionWithSuccess({(success: Bool) -> Void in
                if success {
                    self.startScanning()
                }
                else {
                    self.displayPermissionMissingAlert()
                }
            })
        }
    }
    
    @IBAction func switchCameraTapped(sender: AnyObject) {
        self.scanner.flipCamera()
    }
    
    @IBAction func toggleTorchTapped(sender: AnyObject) {
        if self.scanner.torchMode == MTBTorchMode.Off || self.scanner.torchMode == MTBTorchMode.Auto {
            self.scanner.torchMode = MTBTorchMode.On
            self.toggleTorchButton.title = "Disable Torch"
        }
        else {
            self.scanner.torchMode = MTBTorchMode.Off
            self.toggleTorchButton.title = "Enable Torch"
        }
    }
    
    func backTapped() {
        self.navigationController!.dismissViewControllerAnimated(true, completion: { _ in })
    }
    
    //pragma mark - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier: String = "BarcodeCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = self.uniqueCodes[indexPath.row] as! String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.uniqueCodes.count
    }
    
    //pragma mark - Helper Methods
    
    func displayPermissionMissingAlert() {
        var message: String? = nil
        if MTBBarcodeScanner.scanningIsProhibited() {
            message = "This app does not have permission to use the camera."
        }
        else if !MTBBarcodeScanner.cameraIsPresent() {
            message = "This device does not have a camera."
        }
        else {
            message = "An unknown error occurred."
        }
        
        UIAlertView(title: "Scanning Unavailable", message: message!, delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "").show()
    }
    
    func scrollToLastTableViewCell() {
        var indexPath: NSIndexPath = NSIndexPath(forRow: self.uniqueCodes.count - 1, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
    //pragma mark - Gesture Handlers
    
    func previewTapped() {
        if !self.scanner.isScanning() && !self.captureIsFrozen {
            return
        }
        if !self.didShowCaptureWarning {
            UIAlertView(title: "Capture Frozen", message: "The capture is now frozen. Tap the preview again to unfreeze.", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "").show()
            self.didShowCaptureWarning = true
        }
        if self.captureIsFrozen {
            self.scanner.unfreezeCapture()
        }
        else {
            self.scanner.freezeCapture()
        }
        self.captureIsFrozen = !self.captureIsFrozen
    }
    
    //pragma mark - Setters
    
//    func setUniqueCodes(uniqueCodes: [AnyObject]) {
//        self.uniqueCodes = uniqueCodes
//        self.tableView.reloadData()
//    }
}