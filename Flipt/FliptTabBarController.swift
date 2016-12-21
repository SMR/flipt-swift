//
//  FliptTabBarController.swift
//  Flipt
//
//  Created by Johann Kerr on 12/19/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit

class FliptTabBarController: UITabBarController {
    
    
    lazy var profileVC: ProfileViewController = ProfileViewController()
    lazy var scanVC:ScanViewController = ScanViewController()
    
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
        print("how")
        viewControllers = [profileVC, scanVC]
        viewControllers?[0].tabBarItem.title = "Profile"
        viewControllers?[0].tabBarItem.image = UIImage(named: "profile")
        viewControllers?[1].tabBarItem.title = "Scan"
        viewControllers?[1].tabBarItem.image = UIImage(named:"scan")
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
