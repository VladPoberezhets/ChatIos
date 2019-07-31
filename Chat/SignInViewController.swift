//
//  SignInViewController.swift
//  Chat
//
//  Created by Vlad on 7/17/19.
//  Copyright © 2019 Vlad. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func signUp(_ sender: UIButton) {
            let emails = email.text
            let passwords = password.text

        Auth.auth().createUser(withEmail: emails!, password: passwords!) { (result, error) in
            
               let ref = Database.database().reference().child("user")
            
                ref.child((result?.user.uid)!).setValue(["name": self.name.text!, "email": emails])
            }
        
        let LoginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        present(LoginViewController, animated: true, completion: nil)
        
        
    }
    
 
    
    

}
