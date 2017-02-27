//
//  AppDelegate.swift
//  Flipt
//
//  Created by Johann Kerr on 10/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       // Fabric.with([Crashlytics.self])
       FIRApp.configure()
                
        
 
    
    //TODO: - Add back user login
        
        // check for user login in
        
    
        
       // UINavigationBar.appearance().tintColor = Constants.UI.appColor
        
        //UINavigationBar.appearance().tintColor = UIColor.white
        if User.current != nil {
            
 
            let navVC = UINavigationController()

            let welcomeVC = HomeViewController()
            
            let ftabBarController = FliptTabBarController()
            navVC.viewControllers = [ftabBarController]
            //navVC.viewControllers = [vc]
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = navVC
            self.window?.makeKeyAndVisible()

        } else {
            
            let navVC = UINavigationController()
            

            
            let welcomeVC = HomeViewController()
     
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = welcomeVC
            self.window?.makeKeyAndVisible()
            
                      
        }
 
        
//        
//        let vc = ChatsViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = navVC
//        self.window?.makeKeyAndVisible()

//TODO: - Remove Redundant check for sign in
//        if UserStore.current.signedIn {
//            print("signed in")
//            print(UserStore.current.apiKey)
//            print(UserStore.current.apiSecret)
//            
//            
//        }else{
//            
//            
//            
//            print("not signed in")
//        }
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

