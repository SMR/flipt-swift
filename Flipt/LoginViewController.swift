//
//  LoginViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 12/7/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    lazy var loginView = LoginView()
    let userName = ""
    let password = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.navigationController?.isNavigationBarHidden = false
        loginView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginView.signupBtn.addTarget(self, action: #selector(switchToSignUpView), for: .touchUpInside)
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
        loginView.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {

        view.endEditing(true)
    }
    
   
    
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    
    
    
    
    override func loadView(){
        self.view = loginView
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func login(){
        SVProgressHUD.show()
        loginView.loginBtn.isEnabled = false
        
        let username = loginView.usernameTextField.text!.lowercased()
        
        let password = loginView.passwordTextField.text!.lowercased()
        
        
        FliptAPIClient.login(email: username, password: password) {success in
            
            
            if success {
                
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                    
                    let profileVC = ProfileViewController()
                    
                    let scanVC = ScanViewController()
                    let tabBarController = UITabBarController()
                    tabBarController.view.backgroundColor = UIColor.white
                    tabBarController.viewControllers = [profileVC,scanVC]
                    tabBarController.tabBar.items?[0].image = UIImage(named: "profile")
                    tabBarController.tabBar.items?[0].title = "Profile"
                    tabBarController.tabBar.items?[1].image = UIImage(named: "scan")
                    tabBarController.tabBar.items?[1].title = "Scan"
                    //tabBarController.tabBar.isTranslucent = false
                    
                    let navVC = UINavigationController()
                    
                    
                    let fliptTabBarController = FliptTabBarController()
                    navVC.viewControllers = [fliptTabBarController]
                    self.present(navVC, animated: true, completion: nil)
                }
            }
            //let tabBar = FliptTabBarController()
            
            
            
            //            let lmTabBarController = LMTabBarController()
            //            let navBarController = VerticalOnlyNavigationController()
            //            navBarController.viewControllers = [lmTabBarController]
            //            navBarController.navigationBar.barTintColor = Constants.appColor
            //            lmTabBarController.layerClient = layerClient
            //            lmTabBarController.currentUser = self.currentUser
            //            print("Successfully connected via Layer in Login View Controller")
            //            self.presentViewController(navBarController, animated: true, completion: nil)
            
            
            
            
            
            
            //self.navigationController?.pushViewController(navVC, animated: true)
            //self.present(profileVC, animated: false, completion: nil)
            
            
            
            
        }
    }
    
    
    func switchToSignUpView(){
        self.loginView.switchToSignUpView()
    }


}







