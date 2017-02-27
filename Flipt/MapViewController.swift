//
//  MapViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 2/25/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import Mapbox
import PMAlertController
import Alamofire

class MapViewController: UIViewController  {

    @IBOutlet var mapView: MGLMapView!
    lazy var locationManager: CLLocationManager = CLLocationManager()
    let store = BookDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
        if let location = locationManager.location {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            mapView.longitude = long
            mapView.latitude = lat
            print(long)
            print(lat)
            
        }
        
        mapView.delegate = self

    }
    
    func createPin(for book: Book) {
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: book.lat.toDegrees, longitude: book.long.toDegrees)
        point.title = book.title
        point.subtitle = book.description
        
        mapView.addAnnotation(point)
    }
    
    func contactOwner(book: Book) {
        
        if let ownerId = book.ownerId {
            
            FliptAPIClient.getUserFrom(ownerId, completion: { (user) in
                print("running")
                
                if let userid = user.userid {
                    print(userid)
                    FirebaseApi.checkIfBlocked(userID: userid, completion: { (isBlocked) in
                        if isBlocked {
                            
                        } else {
                            if let firstname = user.firstname, let lastname = user.lastname {
                                
                                
                                
                            }
                            
                            
                            let msgViewController = MessagesViewController()
                            let navVC = UINavigationController(rootViewController: msgViewController)
                            msgViewController.book = book
                            //print(self.owner)
                            if let firstname = user.firstname, let lastname = user.lastname {
                                let lname = user.lastname.characters.first!
                                
                                msgViewController.recipient = "\(firstname) \(lname)"
                            }
                            if let userid = user.userid {
                                msgViewController.recipientId = userid
                                self.present(navVC, animated: true, completion: nil)
                            }
                            
                            
                        }
                        
                        
                    })
                    
                }
                
                
            })
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    



}

// MARK : MGLMapViewDelegate

extension MapViewController: MGLMapViewDelegate {
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    // Or, if you’re using Swift 3 in Xcode 8.0, be sure to add an underscore before the method parameters:
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    /*
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        
        return annotationView
    }
    */
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> UIView? {
        // Only show callouts for `Hello world!` annotation
//        if annotation.responds(to: Selector("title")) && annotation.title! == "Hello world!" {
        
        let books = self.store.nearByBooks.filter { (book) -> Bool in
        
            if book.title == annotation.title!! {
                return true
            } else {
                return false
            }
        }
        let book = books.first!
        
            // Instantiate and return our custom callout view
            return CustomCalloutView(representedObject: annotation, book: book)
       // }
        
       // return nil
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout
        print("Tapped the callout for: \(annotation)")
        
        let books = self.store.nearByBooks.filter { (book) -> Bool in
            
            if book.title == annotation.title!! {
                return true
            } else {
                return false
            }
        }
        let book = books.first!
        
        let title = book.title
        let description = book.description
        Alamofire.request("\(book.coverImgUrl)&zoom=5").responseData { (response) in
            if let imageData = response.data {
                if let image = UIImage(data: imageData) {
                    
                    
                    let alertVC = PMAlertController(title: title, description: description, image:image, style: .alert)
                    
                    
                    
                    alertVC.addAction(PMAlertAction(title: "Contact Owner", style: .default, action: { () in
                        
                        self.contactOwner(book: book)
                        dump(book)
                    }))
                    
                    alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                        
                    }))
                    
                    
                    
                    self.present(alertVC, animated: true, completion: nil)
                  
                }
            }
        }
        
        // Hide the callout
        mapView.deselectAnnotation(annotation, animated: true)
    }
}

// MARK: CLLLocation Manager Delegate

extension MapViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            
        }
        
        
        
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            
            
            if let location = manager.location {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude

                store.getNearByBooks(at: (latitude,longitude)) {

                    
                    for book in self.store.nearByBooks {
                        OperationQueue.main.addOperation {
                            self.createPin(for: book)
                        }
                        
                    }
                }
                
                
            }
            
            
            
            // ...
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    
}





class CustomAnnotationView: MGLAnnotationView {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        
       
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("Hey")
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
    
    
}

