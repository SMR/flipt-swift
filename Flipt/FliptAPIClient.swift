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


//user/books -> GET my books
//book -> POST add book
//books/search -> Get search
//sendbook -> POST send as data bookid and recipient
//book/:bookid  -> POST update book send data
//user -> GET get user
//books/near -> GET near books
//user/:userid -> GET user
//updatePic -> POST update profilePicture
//user -> POST update user

final class FliptAPIClient {
    
    //MARK: - Login
    class func login(email: String, password:String, completion:@escaping (Bool)->()){
        print("RUNNING")
        
        let urlString = "\(Constants.Flipt.baseUrl)/login"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = ["email":"\(email)", "password":"\(password)"]
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
            urlRequest.httpBody = jsonData
        }catch {
            print("no data")
        }
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let jsonData = data else { return }
            do{
                let responseJSON = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                let userJSON = responseJSON["user"] as! [String: Any]
                let user = User(userDictionary: userJSON)
                if let currentuser = user {
                    User.current = currentuser
                    
                    completion(true)
                } else {
                    completion(false)
                }
                
            }catch{
                
            }
            
        }
        
        dataTask.resume()
        
    }
    
    //MARK: - Register
    class func register(email:String, password:String, fullname:String, completion:@escaping (Bool)->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/register"
        print(urlString)
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let json = ["email":"\(email)", "password":"\(password)", "userid":uuid, "fullname": fullname]
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
                
                
                
            }catch{
                
            }
            
            
        }
        
        dataTask.resume()
        
        
    }
    
    //MARK: - Get all user books
    
    class func getAllBooks(completion: @escaping([Book])->()) {
        getBooks { (books) in
            print(books)
            completion(books)
        }
    }
    
    
    //MARK: - Get books near you
    class func getNearBooks(at location: Location,completion: @escaping([Book]) -> ()){
        getBooks(by: location) { (books) in
            completion(books)
        }
    }
    
    //MARK: - GET book by ID
    
    class func getBook(_ id:String, completion: @escaping (Book) -> ()) {
        let urlString = "\(Constants.Flipt.baseUrl)/book/\(id)"
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
                
                let bookJSON = JSON(data: jsonData)
                let book = Book(flipt: bookJSON)
                completion(book)
                
                
            }
            
            dataTask.resume()
        }
        
        
    }

    
    //MARK: - GET user's profile
    class func getUserProfile(completion: @escaping([String:Any])->()) {
        let urlString = "\(Constants.Flipt.userUrl)"
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
    
    
    //MARK: - GET user bookCount
    class func getUser(completion:@escaping (Int)->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/user"
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
    
    
    //MARK: - Update Profile Picture
    
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
    
    //MARK: - Save Book
    class func save(_ book: Book, at location:Location) {
        saveBook(book, at: location)
    }
    
    //MARK: - Download Profile Picture
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

    //MARK: - Update Book
    class func updateBook(id:String, dict:[String: Any], completion: @escaping () -> ()) {
        let urlString = "\(Constants.Flipt.baseUrl)/book/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        
        print(urlString)
        
        let session = URLSession.shared
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            var bookData = [String: Any]()
     
            
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
                    
                    completion()
                    
                }catch{
                    
                }
            }
            
            dataTask.resume()
        }
        
        
    }
    
    //MARK: - Add User Img to Book
    class func addUserImgToBook(id:String, img:String, completion: @escaping () -> ()) {
        let urlString = "\(Constants.Flipt.baseUrl)/book/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        
        print(urlString)
        
        let session = URLSession.shared
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            var bookData = [String: Any]()
            bookData["userimg"] = img
            
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
                    
                    completion()
                    
                }catch{
                    
                }
            }
            
            dataTask.resume()
        }
        
        
    }
    
    



    
}

extension FliptAPIClient {
    
    //MARK:- Get User From Book    
//    http://localhost:8080/api/user/2?type=id
//    http://localhost:8080/api/user/2?type=userid
    class func getUserFrom(_ num: Int, completion:@escaping (User) -> ()) {
        let urlString = "http://localhost:8080/api/user/\(num)?type=id"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let jsonData = data else { return }
                let resultJSON = JSON(data: jsonData)
                let userJSON = resultJSON["user"]
                let user = User(userJSON)
                completion(user)
                
                
            }
            
            dataTask.resume()
        }

        
    }
    
    class func getUserFrom(_ id: String, completion:@escaping (User, [Book])->()) {
        print("id - \(id)")
        let urlString = "http://localhost:8080/api/user/\(id)?type=userid"
        guard let url = URL(string: urlString) else { return }
        print(urlString)
        let session = URLSession.shared
        
        if let apiKey = User.current?.apiKey, let apiSecret = User.current?.apiSecret {
            
            let loginData = "\(apiKey):\(apiSecret)".data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            var urlRequest = URLRequest(url: url)
            
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let jsonData = data else { return }
                let resultJSON = JSON(data: jsonData)
                //print(resultJSON)
                let userJSON = resultJSON["user"]
                let user = User(userJSON)
                //dump(user)
                let bookJSONArray = resultJSON["books"].array ?? []
                var books = [Book]()
                for json in bookJSONArray {
                    let book = Book(flipt: json)
                    books.append(book)
                }
                completion(user, books)
                
                
            }
            
            dataTask.resume()
        }
        
        
    }
    
    
    
    class fileprivate func getBooks(by location: Location, completion: @escaping ([Book])->()) {
        let urlString = "\(Constants.Flipt.baseUrl)/books/near?lat=\(location.0)&long=\(location.1)"
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
    
        let urlString = "\(Constants.Flipt.baseUrl)/user/books"
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
                print(JSON(data:jsonData))
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
    
//    class fileprivate func authenticate(by:Auth, email:String, password:String, completion:@escaping (Bool)->()) {
//        
//    }
}

extension Double {
    
    var ToRadians: Double { return Double(self) * .pi / 180 }
    
}
