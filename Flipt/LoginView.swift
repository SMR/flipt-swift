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
    
    lazy var userNameLabel = UILabel()
    lazy var passwordLabel = UILabel()
    lazy var userNameTextField = UITextField()
    lazy var passwordTextField = UITextField()
    lazy var loginBtn = UIButton()
    lazy var signinBtn = UIButton()
    
    
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
        let views: [UIView] = [userNameLabel,passwordLabel,userNameTextField,passwordTextField,loginBtn,signinBtn]
        views.forEach { (view) in
            self.addSubview(view)
            view.backgroundColor = UIColor.green
        }
        
        createConstraints()
    }
    
    func createConstraints(){
        self.userNameTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.70)
            make.height.equalTo(Constants.UI.textFieldHeight)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(100)
        }
        self.passwordTextField.snp.makeConstraints { (make) in
            make.width.equalTo(self.userNameTextField)
            make.height.equalTo(Constants.UI.textFieldHeight)
            make.centerX.equalTo(self)
            make.top.equalTo(self.userNameTextField.snp.bottom).offset(40)
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(Constants.UI.textFieldHeight)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
    }
    
    
}
