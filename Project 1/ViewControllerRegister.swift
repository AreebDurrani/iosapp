import UIKit

class ViewControllerRegister: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        //handleButtonUI()
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password is empty")
            return
        }
        
      
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "registeredUsername")
        defaults.set(password, forKey: "registeredPassword")
        
        print("User registered: \(username)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}

extension ViewControllerRegister {
    func configureTextFields(){
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.gray.cgColor
        usernameTextField.layer.cornerRadius = 5.0
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.cornerRadius = 5.0
        usernameTextField.frame.size.height = 40
        passwordTextField.frame.size.height = 40
        usernameTextField.layer.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0).cgColor
    }
}

/*extension ViewControllerRegister{
    func handleTextFieldUI() {
        
    }
    
    func handleButtonUI() {
        signInButton.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        signInButton.setTitleColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0), for: .normal)
        if signInButton.isEnabled == true {
            print("button enabled")
            signInButton.backgroundColor = UIColor.red
            print(signInButton)
        }
        else {
            print("button disabled")
            
            signInButton.backgroundColor = UIColor(red: 79/255, green: 79/255, blue: 79/255, alpha: 1.0)
            //signInButton.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for: .normal)
        }
    }
}*/
