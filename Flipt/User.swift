//
//  User.swift
//  Flipt
//
//  Created by Johann Kerr on 12/19/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage



class User {
    struct UserKeys {
        static let id = "id"
        static let username = "username"
        static let apiKey = "apiKey"
        static let apiSecret = "apiSecret"
        static let books = "books"
        static let profilePic = "profilePic"
    }
    
    var id: String!
    var username: String!
    var apiKey: String!
    var apiSecret: String!
    var profilePic: String!
    var latitude:Double?
    var longitude:Double?
    var location: (Double, Double) {
        get {
            if let lat = latitude, let long = longitude{
                return (lat,long)
            }
            return (0,0)
            
        }
    }
    var booksCount: Int!


    init?(userDictionary dict: [String:Any]) {
        guard let id = dict[UserKeys.id] as? Int else { print("id fail");return nil }
        guard let username = dict[UserKeys.username] as? String else { print("username fail");return nil }
        guard let apiKey = dict["api_key_id"] as? String else { print("apiKey fail");return nil }
        guard let apiSecret = dict["api_key_secret"] as? String else { print("apiSecret fail");return nil }
        self.id = String(id)
        self.username = username
        self.apiKey = apiKey
        self.apiSecret = apiSecret
//        self.id = dict[UserKeys.id] as? String ?? ""
//        self.username = dict[UserKeys.username] as? String ?? ""
//        self.apiKey = dict["api_key_id"] as? String ?? ""
//        self.apiSecret = dict["api_key_secret"] as? String ?? ""
//        self.booksCount = dict[UserKeys.books] as? Int ?? 0
    }
    
    init(user: UserDefaults) {
        self.id = user.string(forKey: UserKeys.id) ?? ""
        self.username = user.string(forKey: UserKeys.username) ?? ""
        self.apiKey = user.string(forKey: UserKeys.apiKey) ?? ""
        self.apiSecret = user.string(forKey: UserKeys.apiSecret) ?? ""
        
        self.profilePic = user.string(forKey: UserKeys.profilePic)
    }
    
    
    static var current: User? {
        get {
            if UserDefaults.standard.object(forKey: UserKeys.id) != nil {
                return User(user: UserDefaults.standard)
            }else {
                return nil
            }
        }
        set {
            if let user = current {
                print("setting current User")
                UserDefaults.standard.set(user.id, forKey: UserKeys.id)
                UserDefaults.standard.set(user.apiKey, forKey: UserKeys.apiKey)
                UserDefaults.standard.set(user.apiSecret, forKey: UserKeys.apiSecret)
                UserDefaults.standard.set(user.username, forKey: UserKeys.username)
                UserDefaults.standard.set(user.profilePic, forKey: UserKeys.profilePic)
                
            } else {
                if let user = newValue {
                    UserDefaults.standard.set(user.id, forKey: UserKeys.id)
                    UserDefaults.standard.set(user.apiKey, forKey: UserKeys.apiKey)
                    UserDefaults.standard.set(user.apiSecret, forKey: UserKeys.apiSecret)
                    UserDefaults.standard.set(user.username, forKey: UserKeys.username)
                    UserDefaults.standard.set(user.profilePic, forKey: UserKeys.profilePic)
                } else {
                    print("no new value user")
                }
                
                
            }
            
        }
        
    
        
    }
    
    
    func uploadPicture(data: Data){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        print(data)
        if let currentuser = User.current?.username {
            
            let profileImageRef = storageRef.child("profilePics").child("\(currentuser)")
            print(profileImageRef)
            let uploadTask = profileImageRef.put(data, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
               
                let downloadURL = metadata.downloadURL()?.absoluteString
            
                print(downloadURL)
                guard let url = downloadURL else { return }
                User.current?.profilePic = downloadURL
                print(User.current?.profilePic)
                if let myUser = User.current {
                    print(myUser)
                    FliptAPIClient.update(profilePic: url, completion: { (success) in
                        if success {
                            print("file upload worked")
                        } else {
                            print("File upload failed")
                        }
                    })
                    
                }
                
                
            }
            
        }
       
        
    }
    
    
    
}
