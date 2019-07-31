//
//  LoginViewController.swift
//  Chat
//
//  Created by Vlad on 7/17/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class LoginViewController: UIViewController {
    
   
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
  override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func LogIn(_ sender: UIButton) {
        
        let Email = email.text
        let Password = password.text
        
        let UserTableViewController = storyboard?.instantiateViewController(withIdentifier: "UserTableViewController") as! UserTableViewController
        let UserVCwithNavBar = UINavigationController(rootViewController: UserTableViewController)
        
        Auth.auth().signIn(withEmail: Email!, password: Password!) { (result, error) in
            if error == nil{
                self.present(UserVCwithNavBar, animated: true, completion: nil)
            }
//            else{
//                let userNotification = UIAlertController(title: "Ошыбка", message: "Введен неверный логин или пароль ", preferredStyle: .alert)
//                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                userNotification.addAction(alertAction)
//            }
        }
        
    }
    
    

}
