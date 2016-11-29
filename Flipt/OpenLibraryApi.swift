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

class OpenLibraryApi{
    
    class func getBook(isbn:String){
        let url = "\(Constants.booksApiURL)\(isbn)\(Constants.bookApiParams)"
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else{print("Error");return}
            let json = JSON(data: data)
            
            let bookJSON = json["ISBN:\(isbn)"]
            print(bookJSON)
            
            
            
            
            
            
        }
    }
    
    class func getBook(isbn:String, completion:@escaping (Book)->()){
        let url = "\(Constants.booksApiURL)\(isbn)\(Constants.bookApiParams)"
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else{print("Error");return}
            let json = JSON(data: data)

            let bookJSON = json["ISBN:\(isbn)"]["details"]
                print(bookJSON)
                let book = Book(dict: bookJSON)
                completion(book)

        }
    }
    
}


