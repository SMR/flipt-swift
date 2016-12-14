//
//  LoginViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 12/7/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    lazy var loginView = LoginView()
    let userName = ""
    let password = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        loginView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        
    }
    
    func login(){
        print("logion")
        let username = loginView.userNameTextField.text!.lowercased()
        
        let password = loginView.passwordTextField.text!.lowercased()
        
        print(username)
        print(password)
        FliptAPIClient.login(userName: username, password: password)
    }
    
    override func loadView(){
        self.view = loginView
    }


}







