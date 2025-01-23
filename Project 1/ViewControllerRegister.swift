import UIKit
import CoreData

class ViewControllerRegister: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var reenterPassTextField: UITextField!
    @IBAction func registerPressed(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password is empty")
            let alertController = UIAlertController(title: "Login Failed",
                                                    message: "Invalid username or password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let reenteredPass = reenterPassTextField.text, !reenteredPass.isEmpty else {
            print("Please re-enter password")
            let alertController = UIAlertController(title: "Login Failed",
                                                    message: "Please re-enter your password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if reenteredPass != password {
            let alertController = UIAlertController(title: "Signup Failed",
                                                    message: "Passwords must match!",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }

        // Save the Account to Core Data
        saveAccount(username: username, password: password)
        //Store username into singleton for display
        UsernameManager.shared.username = username
        print("User registered: \(username)")
        
        // Navigate to MainTabController
        /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
        
        self.navigationController?.setViewControllers([vc], animated: true)*/
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }

    private func saveAccount(username: String, password: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Could not get AppDelegate")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new Account entity
        let account = NSEntityDescription.insertNewObject(forEntityName: "Account", into: context)
        account.setValue(username, forKey: "username")
        account.setValue(password, forKey: "password")
        
        do {
            try context.save()
            print("Account saved successfully.")
        } catch {
            print("Failed to save account: \(error.localizedDescription)")
        }
    }
}

extension ViewControllerRegister {
    func configureTextFields(){
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.gray.cgColor
        usernameTextField.layer.cornerRadius = 5.0
        usernameTextField.frame.size.height = 40
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.gray.cgColor
        passwordTextField.layer.cornerRadius = 5.0
        passwordTextField.frame.size.height = 40
        usernameTextField.layer.backgroundColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0).cgColor
        reenterPassTextField.layer.borderWidth = 1
        reenterPassTextField.layer.borderColor = UIColor.gray.cgColor
        reenterPassTextField.layer.cornerRadius = 5.0
        reenterPassTextField.frame.size.height = 40
    }
}
