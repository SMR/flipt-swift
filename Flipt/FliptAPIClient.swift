//
//  FliptAPIClient.swift
//  Flipt
//
//  Created by Johann Kerr on 12/7/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class FliptAPIClient {
    
    static let loginData = "\(User.current?.apiKey):\(User.current?.apiSecret)".data(using: String.Encoding.utf8)!
    static let base64LoginString = loginData.base64EncodedString()
    
    
    class func login(userName: String, password:String, completion:@escaping (Bool)->()){
        authenticate(by: .login, userName: userName, password: password) {success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
            
        }
    }
    
    class func getAllBooks(completion: @escaping([Book])->()) {
        getBooks { (books) in
            print(books)
            completion(books)
        }
        
    }
    
    
    class func getNearBooks(completion: @escaping([Book]) ->()){
        getNearBooks { (books) in
            print(books)
            completion(books)
        }
    }
    class func getUser(completion:@escaping (Int)->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/me"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            
            
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let jsonData = data else { return }
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    let bookCount = responseJSON["books"] as? Int ?? 0
                    let userDict = responseJSON["user"] as! [String:Any]
                    print(responseJSON)
                    let user = User(userDictionary: userDict)
                    print(bookCount)
                    completion(bookCount)
                } catch {
                    
                }
                
            }
            
            dataTask.resume()
            
        }
        
        
    }
    
    
    class func update(profilePic: String, completion: @escaping (Bool)->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/updatePic"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let profileDict = ["profilePic":"\(profilePic)"]
            print(profileDict)
            urlRequest.httpMethod = "POST"
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: profileDict, options: [])
                
                urlRequest.httpBody = jsonData
            } catch {
                print("failed")
            }
            
            print(urlRequest)
            
            
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let jsonData = data else { return }
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    print(responseJSON)
                    let success = responseJSON["success"] as? Bool ?? false
                    
                    if success {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                } catch {
                    
                }
                
            }
            
            dataTask.resume()
            
            
        }
        print(User.current?.apiKey)
        print(User.current?.apiSecret)
        
        
        
        
        
        
        
    }
    
    class func register(userName:String, password:String, completion:@escaping ()->()){
        //authenticate(by: .register, userName: userName, password: password)
        
        authenticate(by: .register, userName: userName, password: password) { success in
            
            if success {
                completion()
            }
            
        }
    }
    
    class func save(_ book: Book, at location:(Double,Double)){
        saveBook(book, at: location)
    }
    
    
    
    
    
}

extension FliptAPIClient {
    
    //MARK:- Get User Books
    
    
    class fileprivate func getNearbyBooks(completion: @escaping ([Book])->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/myBooks"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let jsonData = data else { return }
                let jsonArray = JSON(data: jsonData).array ?? []
                var books = [Book]()
                for json in jsonArray {
                    let book = Book(flipt: json)
                    books.append(book)
                }
                completion(books)
                
                
            }
            
            dataTask.resume()
        }
        
        
    }
    
    
    
    class fileprivate func getBooks(completion: @escaping ([Book])->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/myBooks"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let jsonData = data else { return }
                let jsonArray = JSON(data: jsonData).array ?? []
                var books = [Book]()
                for json in jsonArray {
                    let book = Book(flipt: json)
                    books.append(book)
                }
                completion(books)
                
                
            }
            
            dataTask.resume()
        }
        
        
    }
    
    //MARK:- Save Book to DB
    class fileprivate func saveBook(_ book:Book, at location:(Double,Double)){
        let urlString = "\(Constants.Flipt.baseUrl)/book"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var bookData = book.serialize()
        bookData["latitude"] = location.0
        bookData["longitude"] = location.1
        
        print(UserStore.current.apiSecret)
        print(UserStore.current.apiKey)
        print(FliptAPIClient.base64LoginString)
        urlRequest.setValue("Basic \(FliptAPIClient.base64LoginString)", forHTTPHeaderField: "Authorization")
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: bookData, options: [])
            urlRequest.httpBody = jsonData
        }catch {
            print("no data")
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let jsonData = data else { return }
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                
                
                print(responseJSON)
            }catch{
                
            }
            
            
        }
        
        dataTask.resume()
        
    }
    
    
    //MARK:- Authentication
    
    class fileprivate func authenticate(by:Auth, userName:String, password:String, completion:@escaping (Bool)->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/\(by)"
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = ["username":"\(userName)", "password":"\(password)"]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            urlRequest.httpBody = jsonData
        }catch {
            print("no data")
        }
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let jsonData = data else { return }
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                let user = User(userDictionary: responseJSON)
                if let currentuser = user {
                    User.current = currentuser
                    print("User - \(User.current)")
                    completion(true)
                } else {
                    completion(false)
                }
                ///User.current = user
                //dump(User.current)
                //                let apiKey = responseJSON["api_key_id"] as! String
                //                let apiSecret = responseJSON["api_key_secret"] as! String
                //                UserStore.current.apiKey = apiKey
                //                UserStore.current.apiSecret = apiSecret
                
                
                
            }catch{
                
            }
            
            
        }
        
        dataTask.resume()
        
        
    }
    
    
    
    
}


enum Auth {
    case login
    case register
}




extension FliptAPIClient{
    private func loginUser(user userName:String, password:String){
        
        
        
    }
}
