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
            
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            feedbackGenerator.impactOccurred()
            
            
            let alertController = UIAlertController(title: "Login Successful",
                                                    message: "Welcome back, \(usernameInput)!",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
             
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Invalid username or password")
        }
    }
}

