//
//  BookDetailVC.swift
//  Flipt
//
//  Created by Johann Kerr on 2/25/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class BookDetailVC: UIViewController {

    @IBOutlet weak var bookImageView: UIImageView!
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookAuthorLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var contactBtn: UIButton!
    var book: Book!
    var owner: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBook()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func loadBook(){
        //ownerBtn.backgroundColor = UIColor.black
  
        if let url = URL(string: self.book.coverImgUrl) {
            self.bookImageView.kf.setImage(with: url)
            
        }
        
        if let ownerId = self.book.ownerId {
    
            FliptAPIClient.getUserFrom(ownerId, completion: { (user) in
                print("running")
                self.owner = user
               
                if let userid = user.userid {
                    print(userid)
                    FirebaseApi.checkIfBlocked(userID: userid, completion: { (isBlocked) in
                        if isBlocked {
                            OperationQueue.main.addOperation {
                                self.contactBtn.isEnabled = false
                            
                            }
                        } else {
                            if let firstname = user.firstname, let lastname = user.lastname {
                                
                                
                               // self.bookDetailView.bookOwnedByLabel.text = "This book is owned by \(firstname) \(lastname.characters.first!)"
                                dump(user)
                                
                                // .substring(to: name.index(before: name.endIndex))
                            }
                        }
                        
                        
                    })
                    
                }
                
                // }
                //
                
            })
            
        }
        
        
        
        
    }
    
    
 

    @IBAction func contactBtnPressed(_ sender: Any) {
        
        let msgViewController = MessagesViewController()
        msgViewController.book = self.book
        //print(self.owner)
        if let firstname = self.owner.firstname, let lastname = self.owner.lastname {
            let lname = self.owner.lastname.characters.first!
            
            msgViewController.recipient = "\(firstname) \(lname)"
        }
        msgViewController.recipientId = self.owner.userid
        self.present(msgViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
