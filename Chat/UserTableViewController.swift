//
//  UserTableViewController.swift
//  Chat
//
//  Created by Vlad on 7/25/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewController: UITableViewController {


    var user = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getUser()
        
        //----Конпка з права в navBar---
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(Exit))
    }
    
    //-------Функция вийти------
   @objc func Exit(){
        do{
            try! Auth.auth().signOut()
            let LoginVC = (storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
            self.present(LoginVC, animated: true, completion: nil)
        }
    }
    
    //-----отримуєм список користувачів-----
    func getUser(){
        let uId = Auth.auth().currentUser?.uid
        

            Database.database().reference().child("user").child(uId!).child("name").observe(.value) { (snapshot) in
                self.navigationItem.title = snapshot.value as? String
            }
        


            Database.database().reference().child("user").observe(.childAdded) { (snapshot) in
                
                let users = User()
                users.email = (snapshot.value as! NSDictionary)["email"] as? String ?? ""
                users.name = (snapshot.value as! NSDictionary)["name"] as? String ?? ""
                users.uid = (snapshot.value as! NSDictionary)["uid"] as? String ?? ""
                
                if uId != users.uid{
                    self.user.append(users)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        
       
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let getUser = user[indexPath.row]
            cell.textLabel?.text = getUser.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userForChatVC = user[indexPath.row]
       
        pressentChatViewController(user: userForChatVC)
    }
 
    //-----Передаєм в chatVC інформацію про користувача і добавляєм navBar
    func pressentChatViewController(user:User){
        let ChatViewController = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        ChatViewController?.user = user
        let ChatVCwithNavBar = UINavigationController(rootViewController: ChatViewController!)
        present(ChatVCwithNavBar, animated: true, completion: nil)

    }
}

