import UIKit
import CoreData

class ViewControllerLogin: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        
        if !isAccountRegistered() {
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

        if validateLogin(username: usernameInput, password: passwordInput) {
                print("Login successful")
                
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                feedbackGenerator.impactOccurred()
                
                let alertController = UIAlertController(title: "Login Successful",
                                                        message: "Welcome back, \(usernameInput)!",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                self.navigationController?.setViewControllers([vc], animated: true)*/
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Login Failed",
                                                    message: "Invalid username or password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func isAccountRegistered() -> Bool {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()

        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let accounts = try context.fetch(fetchRequest)
            return !accounts.isEmpty
        } catch {
            print("Error checking accounts: \(error.localizedDescription)")
            return false
        }
    }

    private func validateLogin(username: String, password: String) -> Bool {
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let accounts = try context.fetch(fetchRequest)
            return !accounts.isEmpty
        } catch {
            print("Error validating login: \(error.localizedDescription)")
            return false
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
