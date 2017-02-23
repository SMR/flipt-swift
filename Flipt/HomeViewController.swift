//
//  HomeViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 2/3/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var signUpLayout: NSLayoutConstraint!
    
    @IBOutlet weak var loginInLayout: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        let emailVC = EmailViewController()
        let navVC = UINavigationController(rootViewController: emailVC)
        self.present(navVC, animated: true, completion: nil)
        
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        let loginVC = LoginVC()
        let navVC = UINavigationController(rootViewController: loginVC)
        self.present(navVC, animated: true, completion: nil)
        
    }


}
