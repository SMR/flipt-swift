//
//  ProfileViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 11/22/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView{
    lazy var imageView: UIImageView = UIImageView()
    lazy var profileLabel: UILabel = UILabel()
    lazy var locationLabel: UILabel = UILabel()
    
    init(){
        super.init(frame: CGRect.zero)
        setupViews()
        createConstraints()
    }
    
    override init(frame:CGRect){
        super.init(frame:frame)
        setupViews()
        createConstraints()
    }
    
    func setupViews(){
        let views :[UIView] = [imageView, profileLabel, locationLabel]
        views.forEach { (view) in
            self.addSubview(view)
            view.backgroundColor = UIColor.random
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        createConstraints()
    }
    
    func createConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.width.equalTo(75)
            make.top.equalTo(self).offset(75)
        }
        profileLabel.snp.makeConstraints{(make) in
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(153)
            make.height.equalTo(20)
            
        }
        locationLabel.snp.makeConstraints{(make) in
            make.top.equalTo(profileLabel.snp.bottom)
            make.centerX.equalTo(self)
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        
    }
    
    
}

class ProfileViewController: UIViewController {
    
    
    var collectionView: UICollectionView!
    lazy var profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    let store = BookDataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        print("running")
        setupViews()
        
        
        
        OpenLibraryApi.getBook(isbn: "978-0451191144") { (book) in
            dump(book)
        }
    }

    
    func setupViews(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        
        let cellsPerRow: CGFloat = 3
        let pLength = self.view.bounds.width
        let perimeterLength = floor(pLength / cellsPerRow)
        
        //layout.itemSize = CGSize(width: 110, height: 180)
        layout.itemSize = CGSize(width: perimeterLength - 10, height: 180)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "basicCell")
        
        self.profileHeaderView.backgroundColor = UIColor.red
        self.collectionView.backgroundColor = UIColor.gray
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.profileHeaderView)

        setupConstraints()
    }
    
    func setupConstraints(){
        self.profileHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(55)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(3)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileHeaderView.snp.bottom).offset(-45)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        
        }
    }
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
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


extension UIColor{
    
    class var random: UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
    }
    
}
