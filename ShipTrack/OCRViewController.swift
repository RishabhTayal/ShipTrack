//
//  OCRViewController.swift
//  
//
//  Created by Tayal, Rishabh on 2/26/16.
//
//

import UIKit
import TesseractOCR

class OCRViewController: UIViewController, G8TesseractDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tesseract:G8Tesseract = G8Tesseract(language:"eng+ita");
        //tesseract.language = "eng+ita";
        tesseract.delegate = self;
        tesseract.charWhitelist = "01234567890";
        tesseract.image = UIImage(named: "image_sample.jpg");
        tesseract.recognize();
        
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }
}
