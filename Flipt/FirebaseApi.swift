//
//  FirebaseApi.swift
//  Flipt
//
//  Created by Johann Kerr on 12/14/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

final class FirebaseApi {
    
    static let recipientsKey = "recipients"
    static let userRef = FIRDatabase.database().reference().child("users")
    static let chatRef = FIRDatabase.database().reference().child("chats")
    static let messageRef = FIRDatabase.database().reference().child("messages")
    static let membersRef = FIRDatabase.database().reference().child("members")
    
    
    
    class func login(_ email:String, password:String, completion:@escaping (FIRUser)->()) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let firUser = user {
                    completion(firUser)
                }
                
                
            }
        })
        
    }
    
    class func signUp(_ email:String, password:String, completion:@escaping (FIRUser)->()) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                if let firUser = user {
                    completion(firUser)
                }
                
                
            }
        })
    }
    //
    //    "alovelace": {
    //    "name": "Ada Lovelace",
    //    "contacts": { "ghopper": true },
    //    },
    //
    
    
    class func getAllMessagesfor(chatId:String, completion:@escaping (Message)->()){
        FirebaseApi.messageRef.child(chatId).observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let dict = snapshot.value as? [String:Any] ?? [:]
            let msg = Message(dict)
            completion(msg)
            
        })
    }
    
    class func getLastMessagefor(chatId:String, completion:@escaping (Chat)->()) {
        FirebaseApi.chatRef.child(chatId).observe(.value, with: { (snapshot) in
            let dict = snapshot.value as? [String:Any] ?? [:]
            var chat = Chat(id: chatId, dict: dict)
            
            getRecipient(chatId: chatId, completion: { (receiver) in
                if let recipient = receiver {
                    chat.recipient = recipient
                    completion(chat)
                }
            })
            
           
            
            
        })
    }
    
    
    class func getRecipient(chatId:String, completion:@escaping (String?)->()) {
        FirebaseApi.membersRef.child(chatId).observe(.childAdded, with: { (snapshot) in
            
            if let user = User.current {
                if user.username == snapshot.key {
                    completion(nil)
                } else {
                    completion(snapshot.key)
                }
            }
        })
    }
    
    
    
    class func getAllChats(completion:@escaping (Chat)->()) {
        if let currentUser = User.current {
             FirebaseApi.userRef.child(currentUser.username).child("chats").observe(.childAdded, with: { (snapshot) in
              
                getLastMessagefor(chatId: snapshot.key, completion: { chat in
                    completion(chat)
                })
                print(snapshot.value)
                print(snapshot.key)
                
                
                
             })
        }
       
    }
    
    
    class func sendMessage(chatId:String, text:String, date:Date, completion:()->()) {
        let currentMsgRef = messageRef.child(chatId).childByAutoId()
        //let date = Date().timeIntervalSinceNow
    
        let dateDouble = date.timeIntervalSince1970
        if let currentUser = User.current {
            let dict: [String:Any] = [
                "message":text,
                "timestamp":dateDouble,
                "name":currentUser.username
            ]
            
            currentMsgRef.updateChildValues(dict)
            
            let chatRef = self.chatRef.child(chatId)
            let chatDict: [String:Any] = [
               "lastMessage":text,
               "timestamp": dateDouble,
               "fromUser": currentUser.username
            ]
            chatRef.setValue(chatDict)
            completion()
            // add message
            
            
        }
      
    
    }
    
    
    class func createChat(recipient:String, book:Book, completion:@escaping(String)->()) {
        let membersRef = FirebaseApi.membersRef.childByAutoId()
        let memberKey = membersRef.key
        if let currentUser = User.current {
            let dict: [String:Any] = [
                recipient:true,
                currentUser.username:true,
                "book":book.toFirebase()
            ]
            
            
            membersRef.setValue(dict)
            userRef.child(currentUser.username).child("chats").setValue([memberKey:true])
            userRef.child(recipient).child("chats").setValue([memberKey:true])
            completion(memberKey)
           // membersRef.updateChildValues(dict)
            
        }
        
        
        
        
        
        // add to chat ref
        //add to members
        // add to messages
        
        
        
        
        
        
    }
    class func connectToFirebase() {
        if let currentUser = User.current {
            
            FIRDatabase.database().reference().child("users").child(currentUser.username).observe(.value, with: { (snapshot) in
                
                let userDict = snapshot.value as? [String:Any] ?? [:]
                if userDict.isEmpty {
                    FirebaseApi.userRef.setValue(currentUser.toFirebase())
                }
            })
        }
        
    }
    
    
}
