//
//  ProfileViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 11/22/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import SnapKit
import BarcodeScanner
import PopupDialog
import Alamofire

class ProfileViewController: UIViewController {
    
    
    var collectionView: UICollectionView!
    lazy var profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    let store = BookDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("running")
        setupViews()
        
        let rightBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openBarCode))
        self.navigationItem.rightBarButtonItem = rightBar
        
        store.getSavedBooks()
        self.collectionView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        print("running view did appear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hey")
        store.getSavedBooks()
        self.collectionView.reloadData()
        
    }
    func openBarCode(){
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        present(controller, animated: true, completion: nil)
        
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
        //self.view.addSubview(self.profileHeaderView)
        setupBarcode()
        setupConstraints()
    }
    
    func setupConstraints(){
//        self.profileHeaderView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.view).offset(55)
//            make.left.equalTo(self.view)
//            make.width.equalTo(self.view)
//            make.height.equalTo(self.view).dividedBy(3)
//        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(5)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
            
        }
    }
    
    func show(book:Book){
        let title = book.title
        let message = book.description
        let popup = PopupDialog(title: title, message: message)
        
        
        
        
        // Create buttons
        let cancel = CancelButton(title: "Cancel") {
            popup.dismiss(animated: true, completion: nil)
            self.openBarCode()
        }
        
        let add = DefaultButton(title: "Add to BookShelf") {
            self.store.save(book: book)
            popup.dismiss(animated: true, completion: nil)
            self.openBarCode()
            
        }
        
        popup.addButtons([add, cancel])
        
        
        self.present(popup, animated: true, completion: nil)
        
        
        
        //        let image = UIImage(named: "pexels-photo-103290")
        //
        //        // Create the dialog
        
        
        
    }

    
    
    
}


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.store.savedBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BookCollectionViewCell
        
        
        let book = self.store.savedBooks[indexPath.row]
        cell.configureCell(storedBook: book)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let bookDetailVC = SavedBookDetailViewController()
        bookDetailVC.bookItem = store.savedBooks[indexPath.row]
        self.navigationController?.pushViewController(bookDetailVC, animated: true)
        
        //        OpenLibraryApi.getBook(isbn: "9781626340466") { (book) in
        //            bookDetailVC.book = book
        //            self.navigationController?.pushViewController(bookDetailVC, animated: true)
        //        }
        //let book = Book()
        
        //self.present(bookDetailVC, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}

extension ProfileViewController: BarcodeScannerCodeDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        print(code)
        
        store.getBook(isbn: code) { (book) in
            
            //            controller.dismiss(animated: true, completion: nil)
            controller.dismiss(animated: true, completion: nil)
            DispatchQueue.main.async {
                //controller.reset(animated: true)
                self.show(book: book)
            }
            print(book)
            
        }
        print(type)
        
        //        let delayTime = DispatchTime.now() + Double(Int64(6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        //        DispatchQueue.main.asyncAfter(deadline: delayTime) {
        //            controller.resetWithError()
        //        }
    }
}

extension ProfileViewController: BarcodeScannerErrorDelegate {
    
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        print(error)
    }
}

extension ProfileViewController: BarcodeScannerDismissalDelegate {
    
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension ProfileViewController{
    func setupBarcode(){
        BarcodeScanner.Title.text = NSLocalizedString("Scan barcode", comment: "")
        BarcodeScanner.CloseButton.text = NSLocalizedString("Close", comment: "")
        BarcodeScanner.SettingsButton.text = NSLocalizedString("", comment: "")
        BarcodeScanner.Info.text = NSLocalizedString(
            "Place the barcode within the window to scan. The search will start automatically.", comment: "")
        BarcodeScanner.Info.loadingText = NSLocalizedString("Looking for your book...", comment: "")
        BarcodeScanner.Info.notFoundText = NSLocalizedString("No Book found.", comment: "")
        BarcodeScanner.Info.settingsText = NSLocalizedString(
            "In order to scan barcodes you have to allow camera under your settings.", comment: "")
        
        // Fonts
        BarcodeScanner.Title.font = UIFont.boldSystemFont(ofSize: 17)
        BarcodeScanner.CloseButton.font = UIFont.boldSystemFont(ofSize: 17)
        BarcodeScanner.SettingsButton.font = UIFont.boldSystemFont(ofSize: 17)
        BarcodeScanner.Info.font = UIFont.boldSystemFont(ofSize: 14)
        BarcodeScanner.Info.loadingFont = UIFont.boldSystemFont(ofSize: 16)
        
        // Colors
        BarcodeScanner.Title.color = UIColor.black
        BarcodeScanner.CloseButton.color = UIColor.black
        BarcodeScanner.SettingsButton.color = UIColor.white
        BarcodeScanner.Info.textColor = UIColor.black
        BarcodeScanner.Info.tint = UIColor.black
        BarcodeScanner.Info.loadingTint = UIColor.black
        BarcodeScanner.Info.notFoundTint = UIColor.red
        
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
