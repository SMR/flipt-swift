//
//  ViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 10/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        OpenLibraryApi.getBook(isbn: "9781593083335") { (book) in
            print(book.title)
        }
    }

 
}

