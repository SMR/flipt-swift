//
//  SettingsViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 2/27/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Constants.UI.appColor]
        self.navigationController?.navigationBar.tintColor = Constants.UI.appColor
        self.navigationController?.navigationItem.title = "More"

        // Do any additional setup after loading the view.
    }

    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        User.logOut {

            
            let welcomeVC = WelcomeViewController()
            self.present(welcomeVC, animated: true, completion: nil)
            //remove Subviews
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
