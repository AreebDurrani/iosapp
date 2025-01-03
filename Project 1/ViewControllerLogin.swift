import UIKit

class ViewControllerLogin: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let usernameInput = usernameTextField.text,
              let passwordInput = passwordTextField.text else {
            print("Username or password field is empty")
            return
        }
        
        let defaults = UserDefaults.standard
        let savedUsername = defaults.string(forKey: "registeredUsername")
        let savedPassword = defaults.string(forKey: "registeredPassword")
        
        if usernameInput == savedUsername && passwordInput == savedPassword {
            print("Login successful")
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            print("Invalid username or password")
        }
    }
}
