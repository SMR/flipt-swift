//
//  LoginVC.swift
//  Flipt
//
//  Created by Johann Kerr on 2/15/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBottomConstraint: NSLayoutConstraint!
    
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
            self.loginBottomConstraint.constant = height
            
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    func keyboardWillHide(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.loginBottomConstraint.constant = 120
            self.view.layoutIfNeeded()
        }
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            FliptAPIClient.login(email: email, password: password, completion: { (success) in
                OperationQueue.main.addOperation {
                    let navVC = UINavigationController()
                    
                    let ftabBarController = FliptTabBarController()
                    navVC.viewControllers = [ftabBarController]
                    self.present(navVC, animated: true, completion: nil)
                }
                
                
            })
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
       self.dismiss(animated: true, completion: nil)
    }
    

   

}
