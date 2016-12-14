//
//  UserDataStore.swift
//  Flipt
//
//  Created by Johann Kerr on 12/7/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation

class CurrentUser {
    var apiKey:String
    var apiSecret:String
    
    init(apiKey:String, apiSecret:String) {
        self.apiKey = apiKey
        self.apiSecret = apiSecret
    }
}

final class UserStore {
    static let current = UserStore()
    private init() {}
    
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

    var signedIn: Bool {
        get {
            if apiKey != "" && apiSecret != "" {
                return true
            } else {
                return false
            }
        }
    }
    
    var apiKey: String{
        get {
            let apiKey = UserDefaults.standard.object(forKey: "apiKey") as? String ?? ""
    
            return apiKey
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "apiKey")
            
        }
    }
    var apiSecret: String{
        get {
            if let apiSecret = UserDefaults.standard.object(forKey: "apiSecret") {
                return apiSecret as! String
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "apiSecret")
            
        }
    }
}
