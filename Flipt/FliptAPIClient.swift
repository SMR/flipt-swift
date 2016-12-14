//
//  FliptAPIClient.swift
//  Flipt
//
//  Created by Johann Kerr on 12/7/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import Alamofire

final class FliptAPIClient {
    
    static let loginData = "\(UserStore.current.apiKey):\(UserStore.current.apiSecret)".data(using: String.Encoding.utf8)!
    static let base64LoginString = loginData.base64EncodedString()
    
    
    class func login(userName: String, password:String){
       authenticate(by: .login, userName: userName, password: password)
        
        
    }
    
    class func register(userName:String, password:String){
        authenticate(by: .register, userName: userName, password: password)
    }
    
    class func save(_ book: Book, at location:(Double,Double)){
        saveBook(book, at: location)
    }
    

    
    
    
}

extension FliptAPIClient {
    //MARK:- Book
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
    
    class fileprivate func authenticate(by:Auth, userName:String, password:String) {
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
                
                let apiKey = responseJSON["api_key_id"] as! String
                let apiSecret = responseJSON["api_key_secret"] as! String
                UserStore.current.apiKey = apiKey
                UserStore.current.apiSecret = apiSecret
                print(responseJSON)
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
