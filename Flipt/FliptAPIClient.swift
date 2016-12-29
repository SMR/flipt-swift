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

typealias Location = (Double,Double)

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
    
    
    class func getNearBooks(at location: Location,completion: @escaping([Book]) ->()){
        getBooks(by: location) { (books) in
            completion(books)
        }
    }
    
    
    class func getUserProfile(completion: @escaping([String:Any])->()) {
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
                    completion(responseJSON)
                } catch {
                    
                }
                
            }
            
            dataTask.resume()
            
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
              
        
        
        
    }
    
    class func register(userName:String, password:String, completion:@escaping ()->()){
        //authenticate(by: .register, userName: userName, password: password)
        
        authenticate(by: .register, userName: userName, password: password) { success in
            
            if success {
                completion()
            }
            
        }
    }
    
    class func save(_ book: Book, at location:Location) {
        saveBook(book, at: location)
    }
    
    class func downloadProfPicture(completion:@escaping (Data)->()) {
       
        getUserProfile { (dictionary) in
            let userDict = dictionary["user"] as! [String:Any]
            
           let profilePic = userDict["profilepic"] as? String ?? ""
            guard let url = URL(string: profilePic) else { return }
            let session = URLSession.shared
            let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                guard let unwrappedData = data else { return }
                print(unwrappedData)
                completion(unwrappedData)
                
            })
            dataTask.resume()
            
            
        }
    }
    
    class func getUserFrom(_ id: String, completion:@escaping (User)->()) {
        
        guard let url = URL(string: "") else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let user = User(userDictionary: responseJSON)
                if let unwrappedUser = user {
                    completion(unwrappedUser)
                }
                
            } catch {
                
            }
            
        }
        
    }
    
    
    
    
    
}

extension FliptAPIClient {
    
    //MARK:- Get User Books

    
    class fileprivate func getBooks(by location: Location, completion: @escaping ([Book])->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/near?lat=\(location.0)&long=\(location.1)"
        print(urlString)
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
    class fileprivate func saveBook(_ book:Book, at location:Location){
        let urlString = "\(Constants.Flipt.baseUrl)/book"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var bookData = book.serialize()
        bookData["latitude"] = location.0.ToRadians
        bookData["longitude"] = location.1.ToRadians
        
   
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
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

extension Double {
    
    var ToRadians: Double { return Double(self) * .pi / 180 }
    
}
