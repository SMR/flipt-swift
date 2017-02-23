//
//  UsernameViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 2/9/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {

   
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var continueBtnConstraint: NSLayoutConstraint!
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
        
        if let username = usernameTextField.text, let password = passwordTextField.text {
            self.userDict["username"] = username
            self.userDict["password"] = password
            
            let nameViewController = NameViewController()
            nameViewController.userDict = self.userDict
            self.navigationController?.pushViewController(nameViewController, animated: true)
            
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    

}
