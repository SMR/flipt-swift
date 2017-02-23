//
//  FliptTestBooks.swift
//  Flipt
//
//  Created by Johann Kerr on 1/10/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Flipt
class FliptTestBooks: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
//    init(flipt dict:JSON) {
//        self.publisher = dict["publisher"].string ?? ""
//        self.title = dict["title"].string ?? ""
//        self.fullTitle = dict["title"].string ?? ""
//        self.coverImgUrl = dict["imgUrl"].string ?? ""
//        self.author = dict["author"].string ?? ""
//        self.description = dict["description"].string ?? ""
//        self.publishYear = dict["publishYear"].string ?? ""
//        self.isbn = dict["isbn"].string ?? ""
//        
//    }
    
    
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

    func testBooks() {
        var userDict = [String: Any]()
        userDict[User.UserKeys.id] = 4
        userDict[User.UserKeys.username] = "johann"
        userDict[User.UserKeys.apiKey] = "SEJlNoIrzCCgPB237Eo3KA"
        userDict[User.UserKeys.apiSecret] = "3jaXfS6kCBab3kvlBMVmJw"
        userDict[User.UserKeys.profilePic] = "Johann"
        userDict[User.UserKeys.email] = "Johann"
        userDict[User.UserKeys.firstname] = "Johann"
        userDict[User.UserKeys.lastname] = "Johann"
        userDict[User.UserKeys.phonenumber] = "Johann"
        userDict[User.UserKeys.user_id] = "johann"
        guard let user = User(userDictionary: userDict) else { print("User failed");return }
        User.current = user
        print("starting test")
        FliptAPIClient.getAllBooks { (books) in
            print(books.count)
          
            XCTAssertTrue(books.count > 0)
        }
        

     
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
  
    
}
