//
//  MsgClient.swift
//  Flipt
//
//  Created by Johann Kerr on 12/27/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import SendBirdSDK

class MsgClient {
    class func loginIn() {
        if let currentuser = User.current, let userId = currentuser.id {
            
            SBDMain.connect(withUserId: userId, completionHandler: { (user, error) in
                if let sbdUser = user {
                    User.current?.sbdUser = user
                    
                }
            })
        }
    }
    class func inviteToChat(_ userId:String, book:Book) {
        SBDGroupChannel.createChannel(withUserIds: [userId], isDistinct: true) { (channel,error) in
            if error != nil {
                print("error occured \(error?.localizedDescription)")
                return
            }
            
            print("sccess full creation \(channel)")
            
            
            //store channel somewhere
            channel?.createMetaData(book.toMetaData(), completionHandler: { (dict, error) in
                if error != nil {
                    print("error occured \(error?.localizedDescription)")
                    return
                }
                
                
                
                print("Sucess")
            })
            
        }
    }
    
    class func getUserFrom(userID: String, completion:@escaping (User)->()) {
        FliptAPIClient.getUserFrom(userID) { (user) in
            
            
            completion(user)
        }
    }
    
    
//    channel.sendUserMessage(MESSAGE, data: DATA, completionHandler: { (userMessage, error) in
//    if error != nil {
//    NSLog("Error: %@", error!)
//    return
//    }
    
    // ...
   
    
}


