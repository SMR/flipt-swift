//
//  WelcomeViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 1/10/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    lazy var welcomeView = WelcomeView()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        welcomeView.loginBtn.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        welcomeView.signupBtn.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        
    }
    
    
    func showLogin() {
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    func showSignUp() {
        let signUpVC = RegisterViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
 
    }
    
    
    override func loadView() {
        self.view = welcomeView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }



}
