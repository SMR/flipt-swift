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

class ExploreViewController: UIViewController {
    
    let store = BookDataStore.sharedInstance
    var locationManager: CLLocationManager!
    var collectionView: UICollectionView!
    
    
    var searchBar: UISearchBar!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        print("running")
        SVProgressHUD.show()
        
        let tabBarController = self.tabBarController as! FliptTabBarController
        self.locationManager = tabBarController.locationManager
        
        if let latitude = self.locationManager.location?.coordinate.latitude, let longitude = self.locationManager.location?.coordinate.longitude {
            print((latitude,longitude))
            store.getNearByBooks(at: (latitude,longitude)) {
                print(self.store.nearByBooks.count)
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }
                
                SVProgressHUD.dismiss()
            }
        } else {
            //Location not found
            print("exploreVC - location not found")
        }
        
        
//        store.getNearByBooks {
//            self.collectionView.reloadData()
//            SVProgressHUD.dismiss()
//        }
        
    }
    
       
    func setupViews(){
        
        self.navigationController?.isNavigationBarHidden = false
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 180)
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        self.collectionView.backgroundColor = UIColor.gray
        
        
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
        
    
        cell.configureCell(book: book)
        cell.backgroundColor = UIColor.random
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bookDetailVC = BookDetailViewController()
        let book = self.store.nearByBooks[indexPath.row]
        bookDetailVC.book = book
        self.navigationController?.pushViewController(bookDetailVC, animated: true)
        //self.present(bookDetailVC, animated: true, completion: nil)
        
    }

    
}

extension ExploreViewController: CLLocationManagerDelegate{
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

