//
//  ProfileHeaderView.swift
//  Flipt
//
//  Created by Johann Kerr on 11/29/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import BarcodeScanner
import Hue

class ProfileHeaderView: UIView{
    lazy var backgroundView: UIView = UIView()
    lazy var imageView: UIImageView = UIImageView()
    lazy var profileLabel: UILabel = UILabel()
    lazy var locationLabel: UILabel = UILabel()
    lazy var imageBackground: UIView = UIView()
    
    init(){
        super.init(frame: CGRect.zero)
        setupViews()
        createConstraints()
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        setupViews()
        createConstraints()
    }
    
    func setupViews(){
        let views : [UIView] = [backgroundView,profileLabel, locationLabel,imageBackground,imageView]
        views.forEach { (view) in
            self.addSubview(view)
            //view.backgroundColor = UIColor.random
        }
        self.imageView.backgroundColor = Constants.UI.appColor
        
        
        //self.imageView.backgroundColor = UIColor.lightGray
        
        self.backgroundColor = UIColor.white
        let gradient = [UIColor.red, UIColor.black].gradient()
        
        _ = [UIColor.black, UIColor.orange].gradient { gradient in
            gradient.locations = [0.25, 1.0]
            return gradient
        }
        gradient.bounds = self.backgroundView.bounds
        gradient.frame = self.backgroundView.frame
        
        imageBackground.backgroundColor = UIColor.white
        self.backgroundView.backgroundColor = Constants.UI.appColor
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.backgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundView.addSubview(blurEffectView)
        
        
//        gradient.timeOffset = 0
//        gradient.bounds = navigationController.view.bounds
//        gradient.frame = navigationController.view.bounds
//        gradient.add(animation, forKey: "Change Colors")
       // self.backgroundView.layer.insertSublayer(gradient, at: 0)
        
        
       
        self.imageBackground.layer.cornerRadius = 85.0/2
        
        profileLabel.textAlignment = .center
        imageView.layer.cornerRadius = 37.0
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        createConstraints()
    }
    
    func createConstraints(){
        backgroundView.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(0.5)
            make.width.equalTo(self)
            make.left.equalTo(self)
            make.top.equalTo(self)
        }
        imageBackground.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.width.equalTo(85)
            make.top.equalTo(self).offset(65)
        }
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.width.equalTo(75)
            make.top.equalTo(self).offset(70)
        }
        profileLabel.snp.makeConstraints{(make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalTo(self)
            //make.width.equalTo(153)
            //make.height.equalTo(20)
            
        }
        
        locationLabel.snp.makeConstraints{(make) in
            make.top.equalTo(profileLabel.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
    }
    
    
}
