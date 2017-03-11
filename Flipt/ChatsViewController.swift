//
//  MessagesViewController.swift
//  Flipt
//
//  Created by Johann Kerr on 12/25/16.
//  Copyright © 2016 Johann Kerr. All rights reserved.
//

import UIKit
import FirebaseDatabase
import JSQMessagesViewController
import SVProgressHUD

class ChatsViewController: UITableViewController {

    var ref: FIRDatabaseReference?
    var chatRef: FIRDatabaseReference?
    
    var chats = [Chat]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        self.tableView.register(ChatTableViewCell.self ,forCellReuseIdentifier: "messagesCell")
        
        FirebaseApi.connectToFirebase()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
        self.title = "Chats"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.tabBarController?.navigationItem.title = "Explore"
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.UI.appColor]
        self.tabBarController?.navigationItem.title = "Chats"
     
        
        self.tabBarController?.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Constants.UI.appColor]
   
 
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chats.removeAll()
        self.title = "Chats"
        FirebaseApi.getAllChats { chat in
        
            self.chats.append(chat)
            SVProgressHUD.show()
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
            
        }
    }
    
    deinit {
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.chats.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell", for: indexPath) as! ChatTableViewCell

        
        if self.chats.count > 0 {
            let chat = self.chats[indexPath.row]
            //cell.bookTitleLabel.text = "Johann"

            cell.configureCell(chat: chat)

        }
        
        


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedChat = self.chats[indexPath.row]
        
        
        let msgVC = MessagesViewController()
        msgVC.chatId = selectedChat.id
        msgVC.recipient = selectedChat.recipient
        let navVC = UINavigationController(rootViewController: msgVC)
        self.navigationController?.present(navVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(msgVC, animated: true)
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


