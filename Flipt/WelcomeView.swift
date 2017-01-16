//
//  WelcomeView.swift
//  Flipt
//
//  Created by Johann Kerr on 1/10/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation
import UIKit

class WelcomeView: UIView {
    
    
    lazy var logoImageView = UIImageView()
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
        logoImageView.image = UIImage(named: "logo")
        backgroundImage.image = UIImage(named: "bg")

        loginBtn.setTitle("Login", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = UIColor.black
        signupBtn.setTitle("Create an account", for: .normal)
        signupBtn.setTitleColor(UIColor.white, for: .normal)

        let views: [UIView] = [backgroundImage,loginBtn,signupBtn,logoImageView]
        views.forEach { (view) in
            self.addSubview(view)
        }
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
        
        self.loginBtn.snp.makeConstraints { (make) in
            //            make.left.equalTo(self).offset(20)
            make.center.equalTo(self)
            make.width.equalTo(self).offset(-40)
            make.height.equalTo(40)
            
        }
        
        self.signupBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.loginBtn.snp.bottom).offset(10)
        }
        

    }
    
    
         
}

