//
//  ExploreVC.swift
//  Flipt
//
//  Created by Johann Kerr on 2/26/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import Segmentio
import SnapKit
import Mapbox
import Alamofire
import PMAlertController
import CoreLocation

class ExploreVC: UIViewController {
    
    var segmentioView: Segmentio!
    var mapView: MGLMapView!
    var collectionView: UICollectionView!
    
    lazy var locationManager: CLLocationManager = CLLocationManager()
    let store = BookDataStore.sharedInstance
 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        print("running")
      
        //self.tabBarController?.title = "Explore"
        
        
        self.title = "Explore"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tabBarController?.navigationItem.title = "Explore"
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.UI.appColor]
        setupLocationManager()
        setupSegment()
        setupMapView()
        setupCollectionViews()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constants.UI.appColor]
        self.navigationController?.navigationBar.tintColor = Constants.UI.appColor
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = "Explore"
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            store.getNearByBooks(at: (latitude,longitude)) {
                print("getting nearby books")
                
                for book in self.store.nearByBooks {
                    OperationQueue.main.addOperation {
                        self.createPin(for: book)
                    }
                    
                }
            }
            
            
        }
    }
    
    func setupCollectionViews(){
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 180)
   
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        self.collectionView.backgroundColor = UIColor.lightGray
        
        
        
        self.collectionView.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.segmentioView.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
    }

    
    func setupSegment() {
        
        let segmentioViewRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 125)
        segmentioView = Segmentio(frame: segmentioViewRect)
        view.addSubview(segmentioView)
        var segmentItems = [SegmentioItem]()
        let mapItem = SegmentioItem(title: "Map", image: UIImage(named: "Search"))
        let exploreItem = SegmentioItem(title: "Explore", image: UIImage(named: "Map"))
        segmentItems.append(mapItem)
        segmentItems.append(exploreItem)
        
        
        segmentioView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(125)
            make.width.equalTo(self.view)
        }
    
        
        let indicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 5, color: Constants.UI.appColor)
        
        let horizontalOptions = SegmentioHorizontalSeparatorOptions(
            type: SegmentioHorizontalSeparatorType.bottom, // Top, Bottom, TopAndBottom
            height: 1,
            color: .lightGray
        )
        
        
        let verticalOptions = SegmentioVerticalSeparatorOptions(ratio: 1.0, color: .lightGray)
        
    
        let segmentStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight),
                titleTextColor: .black
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight),
                titleTextColor: .black
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                titleFont: UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight),
                titleTextColor: .black
            )
        )
        
        let segmentOptions = SegmentioOptions(backgroundColor: .white, maxVisibleItems: 2, scrollEnabled: false, indicatorOptions: indicatorOptions, horizontalSeparatorOptions: horizontalOptions, verticalSeparatorOptions: verticalOptions, imageContentMode: .center, labelTextAlignment: .center, labelTextNumberOfLines: 2, segmentStates: segmentStates, animationDuration: 0.1)
        
        segmentioView.setup(content: segmentItems, style: .onlyImage, options: segmentOptions)
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.valueDidChange = { segmentio, segmentIndex in
            print("Selected item: ", segmentIndex)
            if segmentIndex == 0 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mapView.alpha = 0
                    self.collectionView.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.mapView.alpha = 1
                    self.collectionView.alpha = 0
                })
            }
        }
        

        
    }
    
    func setupMapView() {
        self.mapView = MGLMapView(frame: CGRect.zero)
        

        

        if let location = locationManager.location {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            OperationQueue.main.addOperation {
                self.mapView.setCenter(location.coordinate, zoomLevel: 12, animated: true)
                
            }
           

            
        }
        
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.view.addSubview(self.mapView)
        self.mapView.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.top.equalTo(self.segmentioView.snp.bottom)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
       // self.mapView.centerCoordinate = (locationManager.location?.coordinate)!
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

    
    


    

}

extension ExploreVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.nearByBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BookCollectionViewCell
        
        let book = self.store.nearByBooks[indexPath.row]
        dump(book)
        
        cell.configureCell(book: book)
        cell.backgroundColor = UIColor.random
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let book = self.store.nearByBooks[indexPath.row]
        let title = book.title
        let message = book.description
        print(book.coverImgUrl)
        
        Alamofire.request("\(book.coverImgUrl)&zoom=5").responseData { (response) in
            if let imageData = response.data {
                if let image = UIImage(data: imageData) {
                    
                    
                    let alertVC = PMAlertController(title: title, description: message, image:image, style: .alert)
                    
                    
                    
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
        
        
    }
    
}


extension ExploreVC: MGLMapViewDelegate {
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
        if let book = books.first {
            return CustomCalloutView(representedObject: annotation, book: book)
        } else {
            return nil
        }
        
        // Instantiate and return our custom callout view
        
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

extension ExploreVC: CLLocationManagerDelegate{
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
                            self.collectionView.reloadData()
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



