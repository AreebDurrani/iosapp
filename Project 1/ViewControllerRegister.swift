import UIKit

class ViewControllerRegister: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password is empty")
            return
        }
        
        // Save to UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "registeredUsername")
        defaults.set(password, forKey: "registeredPassword")
        
        print("User registered: \(username)")
    }
}
