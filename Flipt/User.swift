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
        static let user_id = "userid"
        static let username = "username"
        static let apiKey = "apiKey"
        static let apiSecret = "apiSecret"
        static let books = "books"
        static let profilePic = "profilePic"
        static let email = "email"
        static let firstname = "firstname"
        static let lastname = "lastname"
        static let phonenumber = "phonenumber"
    }
    
    var id: String!
    var userid: String!
    var username: String!
    var firstname: String!
    var lastname: String!
    var phonenumber: String!
    var email:String!
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
        guard let apiKey = dict[UserKeys.apiKey] as? String else { print("apiKey fail");return nil }
        guard let apiSecret = dict[UserKeys.apiSecret] as? String else { print("apiSecret fail");return nil }
        
        guard let email = dict[UserKeys.email] as? String else { print("email fail"); return nil }
        guard let firstname = dict[UserKeys.firstname] as? String else { print("firstname fail"); return nil }
        
        guard let lastname = dict[UserKeys.lastname] as? String else { print("lastname fail"); return nil }
        
        guard let userid = dict[UserKeys.user_id] as? String else { print("userid fail"); return nil }
        
        self.id = "\(id)"
        self.username = username
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.userid = userid
    

    }
    
    init(user: UserDefaults) {
        self.id = user.string(forKey: UserKeys.id) ?? ""
        self.username = user.string(forKey: UserKeys.username) ?? ""
        self.apiKey = user.string(forKey: UserKeys.apiKey) ?? ""
        self.apiSecret = user.string(forKey: UserKeys.apiSecret) ?? ""
        
        self.profilePic = user.string(forKey: UserKeys.profilePic)
        self.email = user.string(forKey: UserKeys.email)
        self.firstname = user.string(forKey: UserKeys.firstname)
        self.lastname = user.string(forKey: UserKeys.lastname)
        self.phonenumber = user.string(forKey: UserKeys.phonenumber)
        self.userid = user.string(forKey: UserKeys.user_id)
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
            if newValue?.username == current?.username {
                if let user = current {
                    print("setting current User")
                    UserDefaults.standard.set(user.id, forKey: UserKeys.id)
                    UserDefaults.standard.set(user.apiKey, forKey: UserKeys.apiKey)
                    UserDefaults.standard.set(user.apiSecret, forKey: UserKeys.apiSecret)
                    UserDefaults.standard.set(user.username, forKey: UserKeys.username)
                    UserDefaults.standard.set(user.profilePic, forKey: UserKeys.profilePic)
                    UserDefaults.standard.set(user.email, forKey: UserKeys.email)
                    
                    UserDefaults.standard.set(user.firstname, forKey: UserKeys.email)
                    UserDefaults.standard.set(user.lastname, forKey: UserKeys.lastname)
                    UserDefaults.standard.set(user.userid, forKey: UserKeys.user_id)
                    UserDefaults.standard.set(user.phonenumber, forKey: UserKeys.phonenumber)
                    
                }
            } else {
                if let user = newValue {
                    UserDefaults.standard.set(user.id, forKey: UserKeys.id)
                    UserDefaults.standard.set(user.apiKey, forKey: UserKeys.apiKey)
                    UserDefaults.standard.set(user.apiSecret, forKey: UserKeys.apiSecret)
                    UserDefaults.standard.set(user.username, forKey: UserKeys.username)
                    UserDefaults.standard.set(user.profilePic, forKey: UserKeys.profilePic)
                    UserDefaults.standard.set(user.email, forKey: UserKeys.email)
                    
                    UserDefaults.standard.set(user.firstname, forKey: UserKeys.email)
                    UserDefaults.standard.set(user.lastname, forKey: UserKeys.lastname)
                    UserDefaults.standard.set(user.phonenumber, forKey: UserKeys.phonenumber)
                    UserDefaults.standard.set(user.userid, forKey: UserKeys.user_id)
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
    
    
    func toFirebase() -> [String:Any] {
        let fullName = self.firstname != nil && self.lastname != nil ? self.firstname + " " + self.lastname : self.username
        return [
            self.username:[
                "fullname": fullName
            ]
        ]
    }
    
    
    
}
