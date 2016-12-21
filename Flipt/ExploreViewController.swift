//
//  ExploreViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 11/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit
import BarcodeScanner
import SVProgressHUD

class ExploreViewController: UIViewController {
    
    let store = BookDataStore.sharedInstance
    var collectionView: UICollectionView!
    
    var searchBar: UISearchBar!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        print("running")
        SVProgressHUD.show()
        store.getNearByBooks {
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }
        
    }
    
       
    func setupViews(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 110, height: 180)
        
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        self.collectionView.backgroundColor = UIColor.gray
        
        
        self.searchBar = UISearchBar()
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.collectionView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        self.searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchBar.snp.bottom)
        }
    }

   
}


extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BookCollectionViewCell
        
        
        
        let book = Book()
        cell.book = book
        cell.backgroundColor = UIColor.random
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bookDetailVC = BookDetailViewController()
        let book = Book()
        bookDetailVC.book = book
        self.navigationController?.pushViewController(bookDetailVC, animated: true)
        //self.present(bookDetailVC, animated: true, completion: nil)
        
    }

    
}
