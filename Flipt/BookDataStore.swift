//
//  BookDataStore.swift
//  Flipt
//
//  Created by Johann Kerr on 11/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class BookDataStore {
    static let sharedInstance = BookDataStore()
    private init () {}
    
    var savedBooks = [BookItem]()
    var books = [Book]()
    
    var nearByBooks = [Book]()
   
    func getBook(isbn:String, completion:@escaping (Book)->()){
        GoogleBooksApi.getBook(isbn: isbn) { (book,success) in
            if success {
                guard let bookItem = book else { return }
                //self.save(book: bookItem)
                completion(bookItem)
            }else{
                OpenLibraryApi.getBook(isbn: isbn, completion: { (book, success) in
                    if success {
                        guard let bookItem = book else { return }
                        //self.save(book: bookItem)
                        completion(bookItem)
                    }else{
                        print("No book")
                    }
                })
            }
            
        }
        
        
    }
    
    func getNearByBooks(at location:Location, completion: @escaping ()->()) {
        FliptAPIClient.getNearBooks(at: location) { (books) in
            
            self.nearByBooks = books
            completion()
        }
        
    }
    
    func getUserBooks(completion: @escaping ()->()) {
        getSavedBooks()
        
        FliptAPIClient.getUser { bookCount in
            if let currentUser = User.current {
                
                FliptAPIClient.getAllBooks(completion: { (books) in
                    
                    self.save(books: books)
                    self.getSavedBooks()
                    completion()
                    
                })
                
                //                if bookCount != self.savedBooks.count {
                //                    if bookCount > self.savedBooks.count {
                //                        print("Core Data > Server")
                //                    }else {
                //                        print("Server < Core Data")
                //                    }
                //                                    } else {
                //                    print("Server = Core Data")
                //                    // do nothing
                //                }
            }
        }
    }
    
    func uploadUserImagefor(bookId:String, data:Data) {
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        
        let userImageRef = storageRef.child("userimg").child("\(bookId)")
        
        let uploadTask = userImageRef.put(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            
            let downloadURL = metadata.downloadURL()?.absoluteString
            
            
            guard let url = downloadURL else { return }
            
            FliptAPIClient.addUserImgToBook(id: bookId, img: url, completion: {
                
            })
            
        }
        
        
    }
    
    func getSavedBooks(){
        
        // check for differences in count
        
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<BookItem> = BookItem.fetchRequest()
        do {
            self.savedBooks = try context.fetch(fetchRequest)
            print("SavedBooks - \(self.savedBooks.count)")
        }catch{
            
        }
        
    }
    
    func save(books: [Book]) {
        
        
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        
        for book in books {
            let bookItem = BookItem(context: context)
            bookItem.title = book.title
            bookItem.imgUrl = book.coverImgUrl
            bookItem.author = book.author
            bookItem.descriptionText = book.description
            bookItem.publisher = book.publisher
            bookItem.publishYear = book.publishYear
            
        }
        saveContext()
    }
    
   
    
    func save(book: Book) {
        
        let context = persistentContainer.viewContext
        let bookItem = BookItem(context: context)
        bookItem.title = book.title
        bookItem.imgUrl = book.coverImgUrl
        bookItem.author = book.author
        bookItem.descriptionText = book.description
        bookItem.publisher = book.publisher
        bookItem.publishYear = book.publishYear
        saveContext()
        
    }
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Flipt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                //print(nserror)
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    
    
}
