//
//  Book.swift
//  Flipt
//
//  Created by Johann Kerr on 8/14/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Book{
    
    let store = BookDataStore.sharedInstance
    
    var publisher: String
    //var wikiLink: String
    var bookId: String!
    var title:String
    var fullTitle:String
    var coverImgUrl: String
    var subjects = [String]()
    var chapters = [String]()
    var author: String
    var description: String
    var publishYear: String
    var isbn: String
    
    
    init(){
        self.publisher = "Flipt"
        self.title = "Book"
        self.fullTitle = "Book"
        self.coverImgUrl = ""
        self.author = "Author"
        self.description = "Lorem Ipsum"
        self.publishYear = "Dec 13"
        self.isbn = "12345678"
        
    }
    init(flipt dict:JSON) {
        self.publisher = dict["publisher"].string ?? ""
        self.title = dict["title"].string ?? ""
        self.fullTitle = dict["title"].string ?? ""
        self.coverImgUrl = dict["imgUrl"].string ?? ""
        self.author = dict["author"].string ?? ""
        self.description = dict["description"].string ?? ""
        self.publishYear = dict["publishYear"].string ?? ""
        self.isbn = dict["isbn"].string ?? ""
        
    }
    
    init(google dict:JSON) {
        self.publisher = dict["publisher"].string ?? ""
        self.title = dict["title"].string ?? ""
        self.fullTitle = dict["title"].string ?? ""
        
        
        let coverId = dict["imageLinks"]["thumbnail"].string ?? ""
        self.coverImgUrl = coverId.replacingOccurrences(of: "&zoom=1", with: "").replacingOccurrences(of: "http", with: "https")
        
        
        let subjectArray = dict["categories"].array ?? []
        for bookSbj in subjectArray{
            let subject = bookSbj.string ?? ""
            self.subjects.append(subject)
        }
        
        self.chapters = []
//        for chapter in dict["table_of_contents"].arrayValue{
//            let chapter = chapter["title"].string ?? ""
//            self.chapters.append(chapter)
//        }
        
        self.description = dict["description"].string ?? ""
        self.author = dict["authors"][0].string ?? ""
        
        self.publishYear = dict["publishedDate"].string ?? ""
        
        self.isbn = dict["industryIdentifiers"][0]["identifier"].string ?? ""
      
        
    }
    init(dict:JSON, isbn:String) {
        self.publisher = dict["publishers"][0].string ?? ""
        self.title = dict["title"].string ?? ""
        self.fullTitle = dict["full_title"].string ?? ""
        
    
        let coverId = dict["covers"][0].number ?? 0
        self.coverImgUrl = "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg"
        
        
        let subjectArray = dict["subjects"].array ?? []
        for bookSbj in subjectArray{
            let subject = bookSbj.string ?? ""
            self.subjects.append(subject)
        }
        
        for chapter in dict["table_of_contents"].arrayValue{
            let chapter = chapter["title"].string ?? ""
            self.chapters.append(chapter)
        }
        
        self.description = dict["description"]["value"].string ?? ""
        self.author = dict["authors"][0]["name"].string ?? ""
        
        self.publishYear = dict["publish_date"].string ?? ""
        self.isbn = isbn
    }
    

    init(metaData: [String: NSObject]) {
        self.title = metaData["title"] as? String ?? ""
        self.fullTitle = self.title
        self.coverImgUrl = metaData["coverImgUrl"] as? String ?? ""
        self.author = metaData["author"] as? String ?? ""
        self.description = metaData["description"] as? String ?? ""
        self.publisher = metaData["publisher"] as? String ?? ""
        self.publishYear = metaData["publishYear"] as? String ?? ""
        self.isbn = metaData["isbn"] as? String ?? ""
    }
    
    func toMetaData()->[String:String] {
        return [
            "id":"id",
            "title":self.title,
            "imgUrl":self.coverImgUrl,
            "author":self.author,
            "description":self.description,
            "publisher":self.publisher,
            "publishYear":self.publishYear,
            "isbn":self.isbn
        ]
    }

    func toFirebase() -> [String:Any] {
        return [
            "title":self.title,
            "coverImgUrl":self.coverImgUrl
        ]
    }
    func serialize()->[String:Any] {
        //var data = [String:String]()
        //data["title"] = self.title
        //data["img"] = self.coverImgUrl
        return [
            "title":self.title,
            "imgUrl":self.coverImgUrl,
            "isbn": self.isbn,
            "publisher":self.publisher,
            "author":self.author,
            "description":self.author,
            "publishYear":self.publishYear
        ]
        
    }
}


