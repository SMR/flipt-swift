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
import ImagePicker
import Lightbox

class ProfileViewController: UIViewController {
    
    
    var collectionView: UICollectionView!
    lazy var profileHeaderView: ProfileHeaderView = ProfileHeaderView()
    let store = BookDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("running")
        setupViews()
        

        self.collectionView.reloadData()
        
        store.getUserBooks {
            print("From view did load \(self.store.savedBooks.count)")
            self.collectionView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appearing")
        self.setupUser()
        
        self.collectionView.reloadData()
        
        
        let rightBar = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openBarCode))
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.rightBarButtonItem = rightBar
        self.navigationItem.rightBarButtonItem = rightBar
        store.getUserBooks {
            print("From view will appear \(self.store.savedBooks.count)")
            OperationQueue.main.addOperation {
                self.collectionView.reloadData()
            }
            
        }
        
       
        
        
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
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 1
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
        self.collectionView.backgroundColor = UIColor.lightGray
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.profileHeaderView)
        
        //add tap gesture recognizer to profile
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addProfilePic))
        self.profileHeaderView.imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        
        
        setupBarcode()
        setupConstraints()
    }
    

    
    func setupUser(){
        
        
        OperationQueue.main.addOperation {
            if let currentUser = User.current {
                self.profileHeaderView.profileLabel.text = currentUser.username
            }
        }
        
        FliptAPIClient.downloadProfPicture { (data) in
            
                let image = UIImage(data: data)
            OperationQueue.main.addOperation {
                self.profileHeaderView.imageView.image = image
                self.profileHeaderView.imageView.layer.cornerRadius = 34
                self.profileHeaderView.imageView.setNeedsDisplay()
            }
            
        }
    }
    
    func setupConstraints(){
        self.profileHeaderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(3)
        }
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.profileHeaderView.snp.bottom)
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


extension ProfileViewController: ImagePickerDelegate {
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
   
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        guard let image = images.first else { return }
        self.profileHeaderView.imageView.image = image
        let data = UIImagePNGRepresentation(image)
        
        guard let currentUser = User.current else { return }
        if let data = data {
            currentUser.uploadPicture(data: data)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func addProfilePic() {
        print("getting tapped")
        let imagePicker = ImagePickerController()
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
     
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
