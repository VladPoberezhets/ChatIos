//
//  ChatViewController.swift
//  Chat
//
//  Created by Vlad on 7/22/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user:User?
    var userMassages = [UserMassage]()

    
    @IBOutlet weak var massegeText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonSend: UIBarButtonItem!

    
    
    
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = user!.name
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(BackToUserVC))

        
        UserLoadMassage()

        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

    }
    

    
    @objc func hideKeyboard(){
        
        if self.view.endEditing(true) {
            //опускання клавуатури на розмір констрейна
   
            // анімація опускання клавіатури
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    

    @objc func BackToUserVC(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func UserLoadMassage(){
        Database.database().reference().child("Massage").observe(.childAdded) { (snapshot) in
            let userMassage = UserMassage()
            userMassage.FromUid = (snapshot.value as! NSDictionary)["FromUid"] as? String ?? ""
            userMassage.AcceptMasseges = (snapshot.value as! NSDictionary)["AcceptMasseges"] as? [String:Any]
            userMassage.toUid = (snapshot.value as! NSDictionary)["toUid"] as? String ?? ""

            self.userMassages.append(userMassage)
      
            DispatchQueue.main.async {
                 self.tableView.reloadData()
            }
        }
    }

//    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//       self.view.endEditing(true)
//    }
//
    
    @IBAction func sendMassege(_ sender: UIBarButtonItem) {
        let MassegeText = massegeText.text
        let date:Date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let time = "\(hour):\(minute)"
        
        
            _ =  Auth.auth().addStateDidChangeListener { (auth, user) in
            
            let ref = Database.database().reference().child("/").child("Massage")
            let childRef = ref.childByAutoId()
            let userMassage = UserMassage()
            userMassage.FromUid = user?.uid
            userMassage.AcceptMasseges = ["textMassage": MassegeText as Any, "time": time]
            userMassage.toUid = self.user?.uid
            let values = ["FromUid": userMassage.FromUid as Any, "AcceptMasseges": userMassage.AcceptMasseges as Any, "toUid": userMassage.toUid as Any] as [String : Any]
            childRef.updateChildValues(values)
            
//
           self.massegeText.text = ""
      
//            self.userMassages.append(userMassage)
       
            
        }

        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userMassages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMassage", for: indexPath)
            let userSendsMassages = userMassages[indexPath.row]
            print(user?.uid == userSendsMassages.FromUid)
        
        if user?.uid == userSendsMassages.toUid || user?.uid == userSendsMassages.FromUid {
            cell.textLabel?.text = (userSendsMassages.AcceptMasseges!["textMassage"] as! String)
            
            if user?.uid == userSendsMassages.toUid{
                cell.textLabel?.textAlignment = .right
            }else{
                 cell.textLabel?.textAlignment = .left
            }
        }
        
        return cell
    }
    
}
