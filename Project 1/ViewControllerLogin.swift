//
//  ViewControllerLogin.swift
//  Project 1
//
//  Created by Areeb Durrani on 12/30/24.
//

import UIKit

class ViewControllerLogin: UIViewController {
    var username : String?
    var password : String?
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func loginPressed(_ sender: Any) {
            if(usernameTextField.text == username && passwordTextField.text == password){
                performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
   
}
    

