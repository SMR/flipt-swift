//
//  Chat.swift
//  Flipt
//
//  Created by Johann Kerr on 12/28/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation

class Chat {
    
    var recipient: String = ""
    var book: String
    var lastMessageAt: Double
    var lastMessage: String
    var fromUser: String
    var id: String
    
   
    
    init(id:String, book:String, lastMessageAt:Double, lastMessage:String, fromUser: String) {
        self.id = id
        self.book = book
        self.lastMessageAt = lastMessageAt
        self.lastMessage = lastMessage
        self.fromUser = fromUser
    }
    
    init(id:String,dict:[String:Any]) {
        self.id = id
        self.book = dict["book"] as? String ?? ""
        self.lastMessage = dict["lastMessage"] as? String ?? ""
        self.lastMessageAt = dict["timestamp"] as? Double ?? 0.0
        self.fromUser = dict["fromUser"] as? String ?? ""
        
    }
    
    
    func serialize() -> [String:Any] {
        return [
            "book": book,
            "lastMessage": self.lastMessage,
            "timestamp":self.lastMessageAt,
            "fromUser": self.fromUser
        ]
    }
    
    
    
    
}
