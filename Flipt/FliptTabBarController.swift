//
//  FliptTabBarController.swift
//  Flipt
//
//  Created by Johann Kerr on 12/19/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import CoreLocation

class FliptTabBarController: UITabBarController {
    
    
    lazy var profileVC: ProfileViewController = ProfileViewController()
    lazy var scanVC:ScanViewController = ScanViewController()
    lazy var exploreVC: ExploreViewController = ExploreViewController()
    lazy var chatVC: ChatsViewController = ChatsViewController()
    lazy var mapVC: MapViewController = MapViewController()
    lazy var eVC: ExploreVC = ExploreVC()
    

    let store = BookDataStore.sharedInstance
    


    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
        
       // setupLocationManager()
        
        let exploreNav = UINavigationController(rootViewController: eVC)
       exploreNav.navigationItem.title = "Explore"
        exploreNav.title = "Explore"
        //exploreNav.navigationBar.tintColor = Constants.UI.appColor
        let chatNav = UINavigationController(rootViewController: chatVC)
        
        var storyboard: UIStoryboard = UIStoryboard(name: "Settings", bundle: nil)
        var navVC: UINavigationController = storyboard.instantiateViewController(withIdentifier: "Settings") as! UINavigationController
        //exploreNav.navigationBar.tintColor = Constants.UI.appColor
        //viewControllers = [profileVC, scanVC, chatNav, eVC]
      
        viewControllers = [exploreNav, scanVC, chatNav,profileVC, navVC]
        profileVC.navigationController?.isNavigationBarHidden = true
        
        
       
        
        viewControllers?[0].tabBarItem.image = UIImage(named: "explore")
        viewControllers?[0].tabBarItem.title = "Explore"
        
        
        
        viewControllers?[1].tabBarItem.title = "Scan"
        viewControllers?[1].tabBarItem.image = UIImage(named:"scan")
        
        viewControllers?[2].tabBarItem.image = UIImage(named: "messages")
        viewControllers?[2].tabBarItem.title = "Chat"
        
        viewControllers?[3].tabBarItem.title = "Profile"
        viewControllers?[3].tabBarItem.image = UIImage(named: "profile")
        
        viewControllers?[4].tabBarItem.title = "More"
        viewControllers?[4].tabBarItem.image = UIImage(named: "more")
        
        
        self.tabBar.tintColor = Constants.UI.appColor
     
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    

    
}

/*

extension FliptTabBarController: CLLocationManagerDelegate{
    func setupLocationManager(){
        

     
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            
            
            
            self.locationManager.requestLocation()
            
            
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
}


*/


