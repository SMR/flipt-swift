//
//  NameViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 2/14/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {
    
    @IBOutlet weak var continueBtnConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    var userDict = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: .UIKeyboardWillShow,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: .UIKeyboardWillHide,
                           object: nil)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            let height = self.view.frame.size.height/2 - 30
            self.continueBtnConstraint.constant = height
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func keyboardWillHide(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.continueBtnConstraint.constant = 120
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text {
            let fullName = "\(firstName) \(lastName)"
            guard let email = self.userDict["email"] else { return }
            guard let password = self.userDict["password"] else { return }
            
            FliptAPIClient.register(email: email, password: password, fullname: fullName, completion: { (success) in
                if success {
                    
                    let navVC = UINavigationController()
                    
                    let ftabBarController = FliptTabBarController()
                    navVC.viewControllers = [ftabBarController]
                    self.present(navVC, animated: true, completion: nil)
                    
                }
            })
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}
