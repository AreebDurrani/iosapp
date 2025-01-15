import UIKit

class ViewControllerLogin: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "registeredUsername") == nil || defaults.string(forKey: "registeredPassword") == nil {
           
            let alertController = UIAlertController(title: "No Account Found",
                                                    message: "Please tap 'Register' to create a new account.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
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
             
                //self.performSegue(withIdentifier: "loginSegue", sender: self)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                self.navigationController?.setViewControllers([vc], animated: true)
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            print("Invalid username or password")
        }
    }
}

extension ViewControllerLogin {
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

