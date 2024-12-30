//
//  ViewControllerRegister.swift
//  Project 1
//
//  Created by Areeb Durrani on 12/30/24.
//

import UIKit

class ViewControllerRegister: UIViewController {
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let dest = segue.destination as! ViewControllerLogin
        // Pass the selected object to the new view controller.
        username = usernameTextField.text!
        password = passwordTextField.text!
        dest.username = username
        dest.password = password
    }


}
