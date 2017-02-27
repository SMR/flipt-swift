//
//  ExploreViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 11/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit
import BarcodeScanner
import SVProgressHUD
import CoreLocation
import Alamofire
import PopupDialog
import PMAlertController

class ExploreViewController: UIViewController {
    
    let store = BookDataStore.sharedInstance
    lazy var locationManager: CLLocationManager = CLLocationManager()
    var collectionView: UICollectionView!
    
    
    var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.navigationController?.navigationBar.barTintColor = Constants.UI.appColor
        setupViews()
        
        
        
        // SVProgressHUD.show()
        
        
        setupLocationManager()
        
        //        if let manager = self.locationManager, let location = manager.location {
        //            let latitude = location.coordinate.latitude
        //            let longitude = location.coordinate.longitude
        //            print((latitude,longitude))
        //            //TODO: - Change back
        //
        //            var testlat = 40.71949469405151234
        //            var testlong = -73.98507555040615102
        //            store.getNearByBooks(at: (testlat,testlong)) {
        //                print(self.store.nearByBooks.count)
        //                OperationQueue.main.addOperation {
        //                    self.collectionView.reloadData()
        //                }
        //
        //               // SVProgressHUD.dismiss()
        //            }
        //        } else {
        //            //Location not found
        //            //print(self.locationManager)
        //            print("exploreVC - location not found")
        //        }
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.tabBarController?.navigationItem.title = "Explore"
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.UI.appColor]
        
    }
    
    
    func setupViews(){
        
        // self.navigationController?.isNavigationBarHidden = false
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 180)
        //self.title = "Explore"
        //self.navigationItem.title = "Johann"
        //self.navigationController?.navigationItem.title = "Jim"
        //self.navigationController?.navigationBar.tintColor = Constants.UI.appColor
        //
        
        
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        self.collectionView.backgroundColor = UIColor.lightGray
        
        
        self.searchBar = UISearchBar()
        self.collectionView.backgroundColor = UIColor.lightGray
        //self.view.addSubview(self.searchBar)
        self.view.addSubview(self.collectionView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        //        self.searchBar.snp.makeConstraints { (make) in
        //            make.top.equalTo(self.view)
        //            make.left.equalTo(self.view)
        //            make.width.equalTo(self.view)
        //        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
    }
    
    
}


extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
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

extension ExploreViewController: CLLocationManagerDelegate{
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
                //var testlat = 40.71949469405151234
               // var testlong = -73.98507555040615102
                store.getNearByBooks(at: (latitude,longitude)) {
                    print(self.store.nearByBooks.count)
                    OperationQueue.main.addOperation {
                        self.collectionView.reloadData()
                    }
                    
                    // SVProgressHUD.dismiss()
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

