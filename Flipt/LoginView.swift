//
//  LoginView.swift
//  Flipt
//
//  Created by Johann Kerr on 12/7/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import SnapKit
import Foundation

class LoginView: UIView{
    
    lazy var logoImageView = UIImageView()
    
    lazy var userNameLabel = UILabel()
    lazy var passwordLabel = UILabel()
    lazy var usernameDivider = UIView()
    lazy var passwordDivider = UIView()
    lazy var usernameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var loginBtn = UIButton()
    lazy var signupBtn = UIButton()
    lazy var backgroundImage = UIImageView()
    
    
    init(){
        super.init(frame: CGRect.zero)
        configureViews()
        self.backgroundColor = UIColor.white
    }
    override init(frame:CGRect){
        super.init(frame: frame)
        configureViews()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureViews(){
        

        userNameLabel.text = "EMAIL"
        userNameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        userNameLabel.textColor = UIColor.white
        
        usernameTextField.placeholder = "Enter email address"
        usernameTextField.font =  UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        usernameTextField.autocapitalizationType = UITextAutocapitalizationType.none
        usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        usernameTextField.textColor = UIColor.white
        
        usernameDivider.backgroundColor = UIColor.white
        
        
        passwordLabel.text = "PASSWORD"
        passwordLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightThin)
        passwordLabel.textColor = UIColor.white
        
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.textColor = UIColor.white
        passwordTextField.font =  UIFont.systemFont(ofSize: 14, weight: UIFontWeightThin)
        passwordTextField.autocapitalizationType = UITextAutocapitalizationType.none
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.isSecureTextEntry = true
        
        passwordDivider.backgroundColor = UIColor.white


        logoImageView.image = UIImage(named: "logo")
        
        backgroundImage.image = UIImage(named: "bg")
        
        
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = UIColor.black
        signupBtn.setTitle("Create an account", for: .normal)
        signupBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        
        let views: [UIView] = [backgroundImage,userNameLabel,passwordLabel,usernameTextField,passwordTextField,loginBtn,signupBtn, usernameDivider, passwordDivider,logoImageView]
        views.forEach { (view) in
            self.addSubview(view)
        }
        
        
       
        backgroundImage.backgroundColor = UIColor.purple
        
        createConstraints()
    }
    
    
    
    
    func createConstraints() {
        self.backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(75)
        }
        
        self.userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self.logoImageView.snp.bottom).offset(85)
            
        }
       
        self.usernameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            //make.centerX.equalTo(self)
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
        }
        self.usernameDivider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self.usernameTextField.snp.bottom).offset(5)
        }
        
        self.passwordLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self.usernameDivider.snp.bottom).offset(20)
            
        }
        self.passwordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            //make.centerX.equalTo(self)
            make.top.equalTo(self.passwordLabel.snp.bottom).offset(10)
        }
        self.passwordDivider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(5)
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
//            make.left.equalTo(self).offset(20)
            make.centerX.equalTo(self)
            make.width.equalTo(self).offset(-40)
            make.height.equalTo(40)
            make.top.equalTo(self.passwordDivider.snp.bottom).offset(30)
        }
        
        self.signupBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(10)
        }
        

        /*
        self.loginBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(Constants.UI.textFieldHeight)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        } 
        */
    }
    
    
    func switchToSignUpView() {
        UIView.animate(withDuration: 0.8) {
            self.loginBtn.isHidden = true
            self.loginBtn.backgroundColor = nil
            self.signupBtn.backgroundColor = UIColor.black
            self.signupBtn.snp.remakeConstraints({ (make) in
                make.centerX.equalTo(self)
                make.width.equalTo(self).offset(-40)
                make.height.equalTo(40)
                make.top.equalTo(self.passwordDivider.snp.bottom).offset(30)
            })
            UIView.animate(withDuration: 0.3, animations: {
                self.loginBtn.isHidden = false
                
                self.loginBtn.snp.remakeConstraints({ (make) in
                    make.centerX.equalTo(self)
                    make.top.equalTo(self.signupBtn.snp.bottom).offset(15)
                
                })
            })
//            self.signupBtn.snp_remakeConstraints({ (make) in
//                make.width.equalTo(self)
//            })
        }
        
    }
    
}
