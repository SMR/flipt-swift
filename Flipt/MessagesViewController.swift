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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = User.current {
            let fullName = user.firstname != nil && user.lastname != nil ? user.firstname + " " + user.lastname : user.username
            self.senderId = user.username
            self.senderDisplayName = fullName
        }
        
        self.title = recipient
      
        
        FirebaseApi.getAllMessagesfor(chatId: chatId) { (message) in
            dump(message)
            self.addMessage(withId: message.sender, name: message.sender, text: message.text)
            self.finishSendingMessage()
        }
        
        // this might fail
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        print("\n\nChatViewController\ndidPressSend\nbutton: \(button)\ntext: \(text)\nsenderId: \(senderId)\nsenderDisplayName: \(senderDisplayName)\ndate: \(date)\nself.messages.count: \(self.messages.count)\n\n")
        
        
       //send to firebase
        
        FirebaseApi.sendMessage(chatId: self.chatId, text: text, date:date) {
            //self.addMessage(withId: self.senderId, name: self.senderDisplayName, text: text)
            // message sent sound
            JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
            
            // animates sending of message
            finishSendingMessage() // 5
            
            
            // Reset the typing indicator when the Send button is pressed.
            //       isTyping = false

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
    
    // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    
    // Observe Messages
    private func observeMessages(for tag: String) {
        //get message 
        
        
              //self.addMessage(withId: "", name: "", text: "")
        //ads messages to collecton view
        
        
        
    }
    
    
    func blockUser(){
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
