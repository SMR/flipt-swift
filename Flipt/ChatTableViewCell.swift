//
//  ChatTableViewCell.swift
//  Flipt
//
//  Created by Johann Kerr on 1/25/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
    lazy var bookImageView: UIImageView = UIImageView()
    lazy var lastMessageLabel: UILabel = UILabel()
    lazy var recipientLabel: UILabel = UILabel()
    lazy var bookLabel: UILabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(bookImageView)
        self.contentView.addSubview(lastMessageLabel)
        self.contentView.addSubview(recipientLabel)
        self.contentView.addSubview(bookLabel)
        createConstraints()
        
    }
    
    func configureCell(chat: Chat) {
        self.lastMessageLabel.text = chat.lastMessage
        if let book = chat.book {
            if book.coverImgUrl != "" {
                downloadImage(book.coverImgUrl, completion: { (data) in
                    
                    if let image = UIImage(data: data) {
                        OperationQueue.main.addOperation {
                            self.bookImageView.image = image
                        }
                    }
                })
            }
            self.bookLabel.text = book.title
        }
        self.recipientLabel.text = chat.recipient
        
        
        
    }
    
    func downloadImage(_ urlString:String, completion: @escaping (Data) -> ()) {
        guard let url = URL(string:urlString) else { return }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
    
            if let imageData = data {
                completion(imageData)
            }
        }
        dataTask.resume()
        
    }
    func createConstraints() {
//        self.lastMessageLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(self.bookImageView.snp.right).offset(20)
//            make.top.equalTo(self).offset(20)
//        }
        self.recipientLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.bookImageView.snp.right).offset(20)
            make.top.equalTo(self).offset(20)
        }
        self.bookLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.bookImageView.snp.right).offset(20)
            make.top.equalTo(self.recipientLabel.snp.bottom).offset(5)
        }
        self.bookImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

