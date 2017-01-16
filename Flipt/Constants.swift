//
//  Constants.swift
//  Flipt
//
//  Created by Johann Kerr on 8/14/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import BarcodeScanner

struct Constants{
    static let booksApiURL = "https://openlibrary.org/api/books?bibkeys=ISBN:"
    static let bookApiParams = "&jscmd=details&format=json"
    static let appColor = UIColor.blue
    
    static let googleBooksApiUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:"
    static let googleApiKey = "&bookclub-1009"
    static let sendbirdKey = "E164FE4B-6238-429B-B752-8F072D31CBA8"
    static let padding = 20.0

    
    //user/books -> GET my books
    //add book -> POST add book
    //books/search -> Get search
    //sendbook -> POST send as data bookid and recipient
    //book/:bookid  -> POST update book send data
    //user -> GET get user
    //books/near -> GET near books
    //user/:userid -> GET user
    //updatePic -> POST update profilePicture
    //user -> POST update user
    struct Flipt{
        //static let baseUrl = "https://fliptbooks.herokuapp.com/api"
        static let baseUrl = "https://localhost:8080"
        static let sendBookUrl = Flipt.baseApiUrl + "/sendbook"
        static let nearBooksUrl = Flipt.baseApiUrl + "/books/near"
        static let updateProfilePicUrl = Flipt.baseApiUrl + "/updatePic"
        static let userUrl = Flipt.baseApiUrl + "/user"
        static let searchUrl = Flipt.baseApiUrl + "/books/search"
        static let baseApiUrl = Flipt.baseUrl + "/api"
        
    }
    
    struct UI{
        static let padding = 20
        static let textFieldHeight = 50
    }
       
        
}
