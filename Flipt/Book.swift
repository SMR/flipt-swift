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
/*

{
    "ISBN:978-0451191144": {
        "info_url": "https://openlibrary.org/books/OL24739808M/Atlas_shrugged",
        "bib_key": "ISBN:978-0451191144",
        "preview_url": "https://archive.org/details/atlasshrugged00rand",
        "thumbnail_url": "https://covers.openlibrary.org/b/id/6793507-S.jpg",
        "details": {
            "table_of_contents": [
            {
            "title": "Non-contradiction",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The theme",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The chain",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The top and the bottom",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The immovable movers",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The climax of the D'Anconias",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The non-commercial",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The exploiters and the exploited",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The John Galt line",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The sacred and the profane",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Wyatt's torch",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Either-or",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The man who belonged on earth",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The aristocracy of pull",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "White blackmail",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The sanction of the victim",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Account overdrawn",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Miracle metal",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The moratorium on brains",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "By our love",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The face without pain or fear of guilt",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The sign of the dollar",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "A is A",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Atlantis",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The utopia of greed",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Anti-greed",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Anti-life",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "Their brothers' keepers",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The concerto of deliverance",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "\"This is John Galt speaking\"",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The egoist",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "The generator",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            },
            {
            "title": "In the name of the best within us.",
            "type": {
            "key": "/type/toc_item"
            },
            "level": 0
            }
            ],
            "covers": [
            6793507
            ],
            "lc_classifications": [
            "PS3535.A547 A94 1996"
            ],
            "latest_revision": 4,
            "ocaid": "atlasshrugged00rand",
            "ia_box_id": [
            "IA116320"
            ],
            "edition_name": "[35th anniversary ed.].",
            "source_records": [
            "ia:atlasshrugged00rand"
            ],
            "title": "Atlas shrugged",
            "languages": [
            {
            "key": "/languages/eng"
            }
            ],
            "subjects": [
            "Fiction",
            "Objectivism (Philosophy)",
            "Egoism",
            "Capitalism",
            "Protected DAISY"
            ],
            "publish_country": "nyu",
            "by_statement": "Ayn Rand",
            "oclc_numbers": [
            "50997820"
            ],
            "type": {
                "key": "/type/edition"
            },
            "revision": 4,
            "publishers": [
            "Signet"
            ],
            "description": {
                "type": "/type/text",
                "value": "This is the story of a man who said that he would stop the motor of the world, and did. Is he a destroyer or a liberator? Why does he have to fight his battle not against his enemys but against those who need him most? Why does he fight his hardest battle against the woman he loves? You will learn the answers to these questions when you discover the reason behind the baffling events that play havoc with the lives of the amazing men and women in this remarkable book. Tremendous in scope, breathtaking in its suspense, \"Atlas shrugged\" is Ayn Rand's magnum opus, which launched an ideology and a movement. With the publication of this work in 1957, Rand gained an instant following and became a phenomenon. \"Atlas shrugged\" emerged as a premier moral apologia for Capitalism, a defense that had an electrifying effect on millions of readers (and now listeners) who have never heard Capitalism defended in other than technical terms."
            },
            "full_title": "Atlas shrugged",
            "last_modified": {
                "type": "/type/datetime",
                "value": "2012-01-10T15:34:36.343320"
            },
            "key": "/books/OL24739808M",
            "authors": [
            {
            "name": "Ayn Rand",
            "key": "/authors/OL59188A"
            }
            ],
            "publish_places": [
            "New York, N.Y., U.S.A"
            ],
            "pagination": "1079 p. ;",
            "created": {
                "type": "/type/datetime",
                "value": "2011-07-07T02:41:30.625718"
            },
            "dewey_decimal_class": [
            "Fic",
            "813.54"
            ],
            "notes": {
                "type": "/type/text",
                "value": "Includes Reader's guide, p. 1071-1079.\n\nNew introduction by Leonard Peikoff."
            },
            "number_of_pages": 1079,
            "isbn_13": [
            "9780451191144"
            ],
            "isbn_10": [
            "0451191145"
            ],
            "publish_date": "1996",
            "copyright_date": "1992",
            "works": [
            {
            "key": "/works/OL731735W"
            }
            ]
        },
        "preview": "borrow"
    }
}

*/
