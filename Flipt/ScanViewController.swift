//
//  ScanViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 11/30/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import BarcodeScanner
import PopupDialog
import Alamofire
import CoreLocation

class ScanViewController: UIViewController {

    let store = BookDataStore.sharedInstance
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        //openBarCode()
        
//        let controller = BarcodeScannerController()
//        controller.codeDelegate = self
//        controller.errorDelegate = self
//        controller.dismissalDelegate = self
//        
//        addChildViewController(controller)
//        controller.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 40)
//        view.addSubview(controller.view)
//        controller.didMove(toParentViewController: self)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        addChildViewController(controller)
        controller.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 40)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    

    func openBarCode(){
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        present(controller, animated: true, completion: nil)
        
    }

}

extension ScanViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        
        store.getBook(isbn: code) { (book) in
            
            //            controller.dismiss(animated: true, completion: nil)
            controller.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                
                self.show(book: book)
                controller.reset(animated: true)
            }
            print(book)
            
        }
        print(type)
        
        //        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        //        DispatchQueue.main.asyncAfter(deadline: delayTime) {
        //            controller.resetWithError()
        //        }
    }
    
    func show(book:Book){
        let title = book.title
        let message = book.description
        let popup = PopupDialog(title: title, message: message)
        
        
        
        
        // Create buttons
        let cancel = CancelButton(title: "Cancel") {
            popup.dismiss(animated: true, completion: nil)
            //self.openBarCode()
        }
        
        let add = DefaultButton(title: "Add to BookShelf") {
            self.store.save(book: book)
            //FliptAPIClient.save(book, at: UserStore.current.location)
            
            if let latitude = self.locationManager.location?.coordinate.latitude, let longitude = self.locationManager.location?.coordinate.longitude {
               
                
                let location = (latitude,longitude)
                FliptAPIClient.save(book, at: location)
                
            }
        
            
            
           
            //FliptAPIClient.save(book, at: (User.current?.location)!)
            popup.dismiss(animated: true, completion: nil)
            //self.openBarCode()
            
        }
        
        popup.addButtons([add, cancel])
        
        
        self.present(popup, animated: true, completion: nil)
        
        
        
        //        let image = UIImage(named: "pexels-photo-103290")
        //
        //        // Create the dialog
        
        
        
    }

}

extension ScanViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension ScanViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension ScanViewController{
    func setupBarcode(){
        BarcodeScanner.Title.text = NSLocalizedString("Scan barcode", comment: "")
        BarcodeScanner.CloseButton.text = NSLocalizedString("Close", comment: "")
        BarcodeScanner.SettingsButton.text = NSLocalizedString("", comment: "")
        BarcodeScanner.Info.text = NSLocalizedString(
            "Place the barcode within the window to scan. The search will start automatically.", comment: "")
        BarcodeScanner.Info.loadingText = NSLocalizedString("Looking for your book...", comment: "")
        BarcodeScanner.Info.notFoundText = NSLocalizedString("No Book found.", comment: "")
        BarcodeScanner.Info.settingsText = NSLocalizedString(
            "In order to scan barcodes you have to allow camera under your settings.", comment: "")
        
        // Fonts
        BarcodeScanner.Title.font = UIFont.boldSystemFont(ofSize: 17)
        BarcodeScanner.CloseButton.font = UIFont.boldSystemFont(ofSize: 17)
        BarcodeScanner.SettingsButton.font = UIFont.boldSystemFont(ofSize: 17)
        BarcodeScanner.Info.font = UIFont.boldSystemFont(ofSize: 14)
        BarcodeScanner.Info.loadingFont = UIFont.boldSystemFont(ofSize: 16)
        
        // Colors
        BarcodeScanner.Title.color = UIColor.black
        BarcodeScanner.CloseButton.color = UIColor.black
        BarcodeScanner.SettingsButton.color = UIColor.white
        BarcodeScanner.Info.textColor = UIColor.black
        BarcodeScanner.Info.tint = UIColor.black
        BarcodeScanner.Info.loadingTint = UIColor.black
        BarcodeScanner.Info.notFoundTint = UIColor.red
        
    }
    
}


extension ScanViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            

            
            self.locationManager.requestLocation()

            
        }
        
      
        //User.current?.latitude =
      //  User.current?.longitude =
        
        
        
        
        
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
}

