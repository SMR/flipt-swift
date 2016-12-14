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

class ProfileHeaderView: UIView{
    lazy var imageView: UIImageView = UIImageView()
    lazy var profileLabel: UILabel = UILabel()
    lazy var locationLabel: UILabel = UILabel()
    
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
        let views :[UIView] = [imageView, profileLabel, locationLabel]
        views.forEach { (view) in
            self.addSubview(view)
            view.backgroundColor = UIColor.random
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        createConstraints()
    }
    
    func createConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.width.equalTo(75)
            make.top.equalTo(self).offset(75)
        }
        profileLabel.snp.makeConstraints{(make) in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(153)
            make.height.equalTo(20)
            
        }
        locationLabel.snp.makeConstraints{(make) in
            make.top.equalTo(profileLabel.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
    }
    
    
}
