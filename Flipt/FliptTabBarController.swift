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
    var locationManager: CLLocationManager!
    let store = BookDataStore.sharedInstance
    
    /*
    let profileVC = ProfileViewController()
    let scanVC = ScanViewController()
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [profileVC,scanVC]
    tabBarController.tabBar.items?[0].image = UIImage(named: "profile")
    tabBarController.tabBar.items?[0].title = "Profile"
    tabBarController.tabBar.items?[1].image = UIImage(named: "scan")
    tabBarController.tabBar.items?[1].title = "Scan"
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = tabBarController
    self.window?.makeKeyAndVisible()
 */
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
       
        
        setupLocationManager()
        
        let exploreNav = UINavigationController(rootViewController: exploreVC)
//        exploreNav.navigationItem.title = "Explore"
//        exploreNav.title = "Explore"
        //exploreNav.navigationBar.tintColor = Constants.UI.appColor
        let chatNav = UINavigationController(rootViewController: chatVC)
        //exploreNav.navigationBar.tintColor = Constants.UI.appColor
        viewControllers = [exploreNav, profileVC, scanVC, chatNav]
        profileVC.navigationController?.isNavigationBarHidden = true
        
        
       
        
        viewControllers?[0].tabBarItem.image = UIImage(named: "explore")
        viewControllers?[0].tabBarItem.title = "Explore"
        
        viewControllers?[1].tabBarItem.title = "Profile"
        viewControllers?[1].tabBarItem.image = UIImage(named: "profile")
        
        viewControllers?[2].tabBarItem.title = "Scan"
        viewControllers?[2].tabBarItem.image = UIImage(named:"scan")
        
        viewControllers?[3].tabBarItem.image = UIImage(named: "messages")
        viewControllers?[3].tabBarItem.title = "Chat"
        
        
        self.tabBar.tintColor = Constants.UI.appColor
     
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    

    
}



extension FliptTabBarController: CLLocationManagerDelegate{
    func setupLocationManager(){
        
        print("Hey")
     
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            
            
            
            self.locationManager.requestLocation()
            
            print(self.locationManager.location)
            
            
    
        
        
        //User.current?.latitude =
        //  User.current?.longitude =
        
        
        
        
        
        
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
}





