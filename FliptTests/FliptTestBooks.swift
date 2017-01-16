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
    func testBooks() {
        let fliptDict = [
            "publisher": "poop",
            "title":"title",
            "fullTitle":"fullTitle",
            "author": "author",
            "description": "description",
            "isbn": "isbn"
        ]
        

     
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
