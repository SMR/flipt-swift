//
//  BookCollectionViewCell.swift
//  Flipt
//
//  Created by Johann Kerr on 11/22/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit


class BookTitleView: UIView{
    lazy var bookTitleLabel = UILabel()
    init(){
        super.init(frame: CGRect.zero)
        self.addSubview(bookTitleLabel)
        bookTitleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        self.backgroundColor = UIColor.lightGray
        
    }
    override init(frame: CGRect){
        super.init(frame: frame)
        self.addSubview(bookTitleLabel)
        bookTitleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BookCollectionViewCell: UICollectionViewCell {

    lazy var bookCoverImageView = UIImageView()
    lazy var bookTitleView = BookTitleView()
    var book = Book()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bookCoverImageView)
        self.addSubview(bookTitleView)
        self.bookTitleView.bookTitleLabel.text = book.title
        createConstraints()
    }
    
    
    
    func createConstraints(){
        self.bookCoverImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
            
        }
        self.bookTitleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.width.equalTo(self.contentView).offset(-20)
            make.height.equalTo(self.contentView).dividedBy(4)
            make.top.equalTo(self.contentView).offset(10)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
