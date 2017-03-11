//
//  MessagesViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 12/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import FirebaseDatabase

class MessagesViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    
    var chatId: String = ""
    var recipient: String = ""
    var recipientId: String!
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.current {
            self.senderId = user.userid
            let fullName = user.firstname != nil && user.lastname != nil ? user.firstname + " " + user.lastname : user.username
            //self.senderId = user.username
            self.senderDisplayName = fullName
        }
        
        self.title = recipient
        print("msgview running")
        
        if chatId != "" {
            FirebaseApi.getAllMessagesfor(chatId: chatId) { (message) in
                self.addMessage(withId: message.sender, name: message.sender, text: message.text)
                self.finishSendingMessage()
            }
            
            
        }
        
        
        
        
        
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreBtnTapped))
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnTapped))
        self.navigationController?.navigationBar.tintColor = Constants.UI.appColor
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem = moreButton
        self.navigationController!.navigationItem.rightBarButtonItem = moreButton
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    func doneBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func moreBtnTapped() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let blockButton = UIAlertAction(title: "Block User", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            
            FirebaseApi.getRecipientId(chatId: self.chatId, completion: { (recipientId) in
                FirebaseApi.toggleBlock(userID: recipientId, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            })
            
        })
        
        
        
        //        let  deleteButton = UIAlertAction(title: "Delete forever", style: .default, handler: { (action) -> Void in
        //            print("Delete button tapped")
        //        })
        //
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })
        
        
        alertController.addAction(blockButton)
        // alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        FirebaseApi.rootRef.removeAllObservers()
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        print("pressing send")
        
        
        // FirebaseApi.getRecipientId(chatId: self.chatId, completion: { (recipientId) in
        
        
        if let user = User.current {
            FirebaseApi.checkIfBlocked(userID: self.recipientId, completion: { (isBlocked) in
                print("isBlocked - \(isBlocked)")
                
                FirebaseApi.checkForChat(recipient: self.recipientId, completion: { (exists, chatId) in
                    print("Exists - \(exists)")
                    print("Chat \(chatId)")
                    if exists {
                        self.chatId = chatId
                        FirebaseApi.sendMessage(chatId: chatId, text: text, date: Date(), completion: {
                            
                            
                            //self.addMessage(withId: user.userid, name:user.username , text: text)
                            self.finishSendingMessage()
                            
                            
                        })
                        
                        print("send message")
                        
                        
                    } else {
                        print("create chat")
                        FirebaseApi.createChat(recipient: self.recipientId, book: self.book, completion: { (chatId) in
                            print(chatId)
                            self.chatId = chatId
                            FirebaseApi.sendMessage(chatId: chatId, text: text, date: Date(), completion: {
                                
                                
                                //self.addMessage(withId: user.userid, name:user.username , text: text)
                                self.finishSendingMessage()
                                
                                
                            })
                        })
                        
                    }
                })
            })
        }
        
        if chatId != "" {
            FirebaseApi.getAllMessagesfor(chatId: chatId) { (message) in
                self.addMessage(withId: message.sender, name: message.sender, text: message.text)
                self.finishSendingMessage()
            }
            
            
        }
        
        
        
        
        

    }
    
    // MARK: Create Messages/ Create JSQMessage objects and append to array
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
            
            self.collectionView.reloadData()
        }
    }
    
    // MARK: Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    // Here you retrieve the message.
    // If the message was sent by current user, return the outgoing image view.
    // Otherwise, return the incoming image view.
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    // Does not display avatar
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        return nil
    }
    
    // Change text color for bubble
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        print("do nothing")
    }
    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        //UIColor.jsq_messageBubbleBlue()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: Constants.UI.appColor)
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    
    
}
