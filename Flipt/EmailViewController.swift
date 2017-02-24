//
//  EmailViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 2/3/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {
    
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
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
            //            self.bottomLayout.constant.add(175.0)
            
            let height = self.view.frame.size.height/2 - 30
            self.bottomLayout.constant = height
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func keyboardWillHide(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.bottomLayout.constant = 120
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func continueBtnPressed(_ sender: Any) {
        if emailTextField.text == "" {
            
        } else {
            if let email = emailTextField.text {
                self.userDict["email"] = email
                let userNameVC = UsernameViewController()
                userNameVC.userDict = self.userDict
                self.navigationController?.pushViewController(userNameVC, animated: true)
            }
        }
        
        
        
    }
    
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
