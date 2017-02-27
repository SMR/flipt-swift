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
    
    // GET ALL MESSAGES FOR EACH CHAT
    // CHAT ID SHOULD BE BOOKID
    class func getAllMessagesfor(chatId:String, completion:@escaping (Message)->()){
        FirebaseApi.messageRef.child(chatId).observe(.childAdded, with: { (snapshot) in
            print("Message Snapshot \(snapshot)")
            let dict = snapshot.value as? [String:Any] ?? [:]
            let msg = Message(dict)
            print("Message - \(msg)")
            completion(msg)
            
        })
    }
    
    class func getLastMessagefor(chatId:String, completion:@escaping (Chat)->()) {
        FirebaseApi.chatRef.child(chatId).observe(.value, with: { (snapshot) in
            let dict = snapshot.value as? [String:Any] ?? [:]
            print("last message \(dict)")
            let chat = Chat(id: chatId, dict: dict)
            print("Chat message -\(chat.lastMessage)")
            FirebaseApi.getRecipient(chatId: chatId, completion: { (receiver, book) in
                print("Receiver \(receiver)")
                if let recipient = receiver, let book = book {
                    chat.book = book
                    chat.recipient = recipient
                    completion(chat)
                }
            })
            
            
            
            
        })
    }
    class func checkIfBlocked(userID: String, completion: @escaping (Bool) -> ()) {
        if let user = User.current, let userid = user.userid {
            FirebaseApi.userRef.child(userid).child("blocked").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let blockedDict = snapshot.value as? [String: Any] {
                    
                    if let blocked = blockedDict[userID] as? Bool {
                        if blocked {
                            print("Is blocked")
                            completion(true)
                        } else {
                            
                            print("is not blocked")
                            completion(false)
                        }
                    } else {
                        
                        print("Is not blocked")
                        completion(false)
                    }
                    
                    
                } else {
                    completion(false)
                }
 
            })
 
        }
    }
    
    class func toggleBlock(userID: String, completion: @escaping () ->()) {
        checkIfBlocked(userID: userID) { (isBlocked) in
            if isBlocked {
                unblockUser(userId: userID, completion: {
                    // should not be blocked
                    completion()
                })
            } else {
                print("bloking user")
                blockUser(userId: userID, completion: {
                    
                    // should be blocked
                    completion()
                })
            }
        }
        
    }
    
    
    class func blockUser(userId: String, completion: @escaping () -> ()) {
        if let user = User.current, let userid = user.userid {
          
            FirebaseApi.userRef.child(userid).child("blocked").updateChildValues([userId: true])
        }
    }
    
    class func unblockUser(userId: String, completion: @escaping () -> ()) {
        if let user = User.current, let userid = user.userid {
            FirebaseApi.userRef.child(userid).child("blocked").updateChildValues([userId: false])
        }
        
    }
    
    class func getRecipientId(chatId:String , completion: @escaping (String) -> ()) {
        FirebaseApi.membersRef.child(chatId).observe(.value, with: { (snapshot) in
            
            if let user = User.current {
                
                let dict = snapshot.value as! [String: Any]
                for key in dict.keys {
                    if key == user.userid || key == "book" {
                        print("Skipping key \(key)")
                        // completion(nil, nil)
                    } else {
                        // get username from snapshot.key
                        completion(key)
                        
                    }
                }
                
                
            }
        })
    }
    //TODO:- FIX!!
    class func getRecipient(chatId:String, completion:@escaping (String?, Book?)->()) {
        FirebaseApi.membersRef.child(chatId).observe(.value, with: { (snapshot) in
            
            if let user = User.current {
                
                let dict = snapshot.value as! [String: Any]
                for key in dict.keys {
                    if key == user.userid || key == "book" {
                    } else {
                        
                        FliptAPIClient.getUserFrom(key, completion: { (user, books) in
                            
                            
                            print(user.firstname)
                            if user.name != "" {
                                print(user.name)
                                
                                let bookDict = dict["book"] as! [String: Any]
                                let bookId = bookDict["bookid"] as! String
                                FliptAPIClient.getBook(bookId, completion: { (book) in
                                    
                                    completion(user.name, book)
                                })
                                
                                
                            } else {
                                
                            }
                        })
                        
                    }
                }
               
                
            }
        })
    }
    
    
    //GET ALL CHATS
    class func getAllChats(completion:@escaping (Chat)->()) {
        if let currentUser = User.current {
            print("Current User userid \(currentUser.userid)")
            FirebaseApi.userRef.child(currentUser.userid).child("chats").observe(.childAdded, with: { (snapshot) in
                
                FirebaseApi.getRecipientId(chatId: snapshot.key, completion: { (recipientId) in
                    FirebaseApi.checkIfBlocked(userID: recipientId, completion: { (isBlocked) in
                        if isBlocked {
                            // should not show 
                            print("Blocked Person - Chat")
                        } else {
                            getLastMessagefor(chatId: snapshot.key, completion: { chat in
                                print("Last message - \(chat.lastMessage)")
                                completion(chat)
                            })
                            
                        }
                    })
                })
                
                
                //print(snapshot.key)
                
                
                
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
                "name":currentUser.userid
            ]
            
            currentMsgRef.updateChildValues(dict)
            
            let chatRef = self.chatRef.child(chatId)
            let chatDict: [String:Any] = [
                "lastMessage":text,
                "timestamp": dateDouble,
                "fromUser": currentUser.userid
            ]
            chatRef.setValue(chatDict)
            completion()
            // add message
            
            
        }
        
        
    }
    
    class func checkForChat(recipient: String, completion:@escaping (Bool, String) -> ()) {
        if let currentUser = User.current {
            _ = FirebaseApi.userRef.child(currentUser.userid).child("chats").observe(.childAdded, with: { (snapshot) in
                let chatId = snapshot.key
                
                
                FirebaseApi.membersRef.child(chatId).observe(.value, with: { (snapshot) in
                    
                    if let user = User.current {
                        
                        let dict = snapshot.value as! [String: Any]
                        for key in dict.keys {
                            if key == user.userid || key == "book" {
                            } else {
                                if recipient == key {
                                    completion(true, chatId)
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                })

               
                
            })
            
            
            
            
        }
    }
    
    // chat id in member is for the chat
    class func createChat(recipient:String, book:Book, completion:@escaping(String)->()) {
        let membersRef = FirebaseApi.membersRef.childByAutoId()
        let memberKey = membersRef.key
        if let currentUser = User.current {
            let dict: [String:Any] = [
                recipient:true,
                currentUser.userid: true,
                //currentUser.username:true,
                "book":book.toFirebase()
            ]
            
            
            membersRef.setValue(dict)
            
            userRef.child(currentUser.userid).child("chats").updateChildValues([memberKey:true])
            userRef.child(recipient).child("chats").updateChildValues([memberKey:true])
            //            userRef.child(currentUser.userid).child("chats").setValue([memberKey:true])
            //            userRef.child(recipient).child("chats").setValue([memberKey:true])
            completion(memberKey)
            // membersRef.updateChildValues(dict)
            
        }
        
        
        
        
        
        // add to chat ref
        //add to members
        // add to messages
        
        
        
        
        
        
    }
    class func connectToFirebase() {
        if let currentUser = User.current {
            
            FIRDatabase.database().reference().child("users").child(currentUser.userid).observe(.value, with: { (snapshot) in
                
                let userDict = snapshot.value as? [String:Any] ?? [:]
                if userDict.isEmpty {
                    FirebaseApi.userRef.setValue(currentUser.toFirebase())
                }
            })
        }
        
    }
    
    
}
