//
//  SignInViewController.swift
//  Chat
//
//  Created by Vlad on 7/17/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class SignInViewController: UIViewController {
    

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override  func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func signUp(_ sender: UIButton) {
            let emails = email.text
            let passwords = password.text
        let confirmPasswords = confirmPassword.text
        
            let alert = UIAlertController(title: "Ошибка", message: "Данные введены неверно", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(alertAction)

        
            Auth.auth().createUser(withEmail: emails!, password: passwords!) { (result, error) in
         
                if passwords!.count < 8 {
                    self.present(alert, animated: true)
                }else{
                    
                    if confirmPasswords != passwords{
                        let alertPassword = UIAlertController(title: "Ошибка", message: "Пароли не совпадают", preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                        alertPassword.addAction(alertAction)
                    }else{
                        let ref = Database.database().reference().child("/").child("user")
                        ref.child((result?.user.uid)!).setValue(["name": self.name.text!, "email": emails, "uid": result?.user.uid])
                        
                        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        
                        
                        self.present(LoginViewController, animated: true, completion: nil)
                    }
                    
                    
                }
            }
        
        
        

        
        
    }
    
 
    
    

}
