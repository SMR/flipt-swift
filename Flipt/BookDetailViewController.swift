//
//  BookViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 11/24/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit


class BookDetailView: UIView{
    lazy var coverImageView = UIImageView()
    lazy var bookTitleLabel = UILabel()
    lazy var authorLabel = UILabel()
    //lazy var segmentController = UISegmentedControl()
    lazy var divider = UIView()
    
    lazy var bookDescriptionLabel = UILabel()
    lazy var bookDescriptionTextView = UITextView()
    lazy var bookOwnedByLabel = UILabel()
    lazy var profileImageView = UIImageView()
    lazy var profileLabel = UILabel()
    lazy var middleDivider = UIView()
    lazy var bottomDivider = UIView()
    lazy var messageOwnerBtn = UIButton()
    
    
    
    
    func createViews(){
        var viewArray = [coverImageView, bookTitleLabel, authorLabel, divider, bookDescriptionLabel, bookDescriptionTextView, bookOwnedByLabel, profileImageView, profileLabel, middleDivider, bottomDivider, messageOwnerBtn]
        viewArray.forEach { (view) in
            self.addSubview(view)
            view.backgroundColor = UIColor.random
        }
        
        self.coverImageView.backgroundColor = UIColor.random
        
        
        createConstraints()
        
    }
    
    init(){
        super.init(frame: CGRect.zero)
        createViews()
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createConstraints(){
        self.coverImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(75)
            make.width.equalTo(60)
            make.height.equalTo(90)
        }
        
        self.bookTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.coverImageView.snp.right).offset(25)
            make.top.equalTo(self.coverImageView)
            make.width.equalTo(210)
            make.height.equalTo(35)
            
        }
        self.authorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.bookTitleLabel)
            make.top.equalTo(self.bookTitleLabel.snp.bottom)
            make.width.equalTo(bookTitleLabel)
            make.height.equalTo(self.bookTitleLabel)
            
        }
        //        self.segmentController.snp.makeConstraints { (make) in
        //
        //
        //        }
        self.divider.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.left.equalTo(self)
            make.top.equalTo(self.coverImageView.snp.bottom).offset(20)
        }
        
        self.bookDescriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.divider.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(self.authorLabel)
            make.height.equalTo(self.authorLabel)
        }
        
        self.bookDescriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bookDescriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(self).offset(-20)
            make.height.equalTo(110)
            
        }
        self.bookOwnedByLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bookDescriptionTextView.snp.bottom).offset(20)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
        self.middleDivider.snp.makeConstraints { (make) in
            make.top.equalTo(self.bookOwnedByLabel.snp.bottom).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.left.equalTo(self)
        }
        
        
        self.profileImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.middleDivider.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        self.profileLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.profileImageView)
            make.left.equalTo(self.profileImageView.snp.right).offset(20)
            make.width.equalTo(self.authorLabel)
            make.height.equalTo(self.authorLabel)
        }
        
        self.bottomDivider.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileLabel.snp.bottom).offset(10)
            make.left.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(1)
        }

        self.messageOwnerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomDivider.snp.bottom).offset(40)
            make.width.equalTo(150)
            make.height.equalTo(50)
            make.centerX.equalTo(self)
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
}



class BookDetailViewController: UIViewController {
    
    var book: Book!
    
    lazy var bookDetailView = BookDetailView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
    }
    
    override func loadView(){
        super.loadView()
        self.view = bookDetailView
        
    }
    
    
}
