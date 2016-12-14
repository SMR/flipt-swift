//
//  GoogleBooksApi.swift
//  Flipt
//
//  Created by Johann Kerr on 11/29/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class GoogleBooksApi {
    
    class func getBook(isbn:String, completion:@escaping (Book?,Bool)->()){
        let url = "\(Constants.googleBooksApiUrl)\(isbn)\(Constants.googleApiKey)"
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else{print("Error");return}
            let json = JSON(data: data)
            print(json.isEmpty)
            
            if json.isEmpty {
                print("not stuff")
                completion(nil, false)
            }else{
                let bookJSON = json["items"][0]["volumeInfo"]
                let book = Book(google: bookJSON)
                completion(book, true)
            }
            
            
        }
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




