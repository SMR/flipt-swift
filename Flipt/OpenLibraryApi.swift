//
//  GoogleBooksApi.swift
//  Flipt
//
//  Created by Johann Kerr on 8/14/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class OpenLibraryApi {

    class func getBook(isbn:String, completion:@escaping (Book?, Bool)->()){
        let url = "\(Constants.booksApiURL)\(isbn)\(Constants.bookApiParams)"
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else{print("Error");return}
            let json = JSON(data: data)
            print(json.isEmpty)
            
            if json.isEmpty {
               print("not stuff")
                completion(nil, false)
            }else{
                let bookJSON = json["ISBN:\(isbn)"]["details"]
                let book = Book(dict: bookJSON, isbn: isbn)
                completion(book, true)
            }
            

        }
    }
    
    class func getBook(bytitle title:String, completion:@escaping (Book?, Bool)->()){
        
        let searchTitle = title.replacingOccurrences(of: " ", with: "+")
        let searchUrl = "https://openlibrary.org/search.json?title=\(searchTitle)"
        Alamofire.request(searchUrl).responseData { (response) in
            guard let data = response.data else { return }
            let json = JSON(data: data)
            let newIsbn = json["docs"][0]["isbn"][0].string ?? ""
           
            
            getBook(isbn: newIsbn, completion: { (book, success) in
                if success {
                    guard let bookitem = book else { return }
                    completion(bookitem, true)
                }else{
                    completion(nil, false)
                }
            })
        }
//        let url = "\(Constants.booksApiURL)\(isbn)\(Constants.bookApiParams)"
//        Alamofire.request(url).responseJSON { (response) in
//            guard let data = response.data else{print("Error");return}
//            let json = JSON(data: data)
//            print(json.isEmpty)
//            
//            if json.isEmpty {
//                print("not stuff")
//                completion(nil, false)
//            }else{
//                let bookJSON = json["ISBN:\(isbn)"]["details"]
//                let book = Book(dict: bookJSON)
//                completion(book, true)
//            }
//            
//            
//        }
    }
    
    
    

    
    
}


