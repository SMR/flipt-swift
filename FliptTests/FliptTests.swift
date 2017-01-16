//
//  FliptTests.swift
//  FliptTests
//
//  Created by Johann Kerr on 1/3/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import XCTest
@testable import Flipt

class FliptTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    
    
    func testChangeCurrentUserValue() {
        if User.current != nil {
            User.current?.username = "johannkerr"
            User.current?.firstname = "firstname"
            XCTAssertEqual(User.current?.username, "johannkerr")
            XCTAssertEqual(User.current?.firstname, "firstname")
        }
    }
    
    func testCreateNewCurrentUser() {
        
        let userDict: [String:Any] = [
            "id":0,
            "userid":"abcd",
            "username":"johannkerr",
            "apiKey": "apiKey",
            "apiSecret":"apiSecret",
            "profilePic":"profilePic",
            "email":"email",
            "firstname":"johann",
            "lastname":"kerr",
            "phonenumber": "phonenumber"
        ]
        let newUser = User(userDictionary: userDict)
    
        User.current = newUser
        
        if let user = User.current {
            XCTAssertEqual(user.id, "0")
            XCTAssertEqual(user.userid, "abcd")
            XCTAssertEqual(user.username, "johannkerr")
            
            
            
            
        }
    }
    
    func createABook() {
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
