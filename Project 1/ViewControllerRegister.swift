import UIKit

class ViewControllerRegister: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
