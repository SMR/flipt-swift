//
//  ChatCell.swift
//  Flipt
//
//  Created by Johann Kerr on 2/26/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit
import Kingfisher

class ChatCell: UITableViewCell {

    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
//    var book: Book? {
//        didSet {
//            if let unwrappedbook = book {
//                bookTitleLabel.text = unwrappedbook.title
//                if let url = URL(string: unwrappedbook.coverImgUrl) {
//                    bookImageView.kf.setImage(with: url)
//                }
//            }
//        }
//    }
//    
//    var chat: Chat? {
//        didSet {
//            if let unwrappedchat = chat {
//                //ownerLabel.text = unwrappedchat.recipient
//            }
//        }
//    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureCell(book: Book) {
        self.bookTitleLabel.text = book.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
