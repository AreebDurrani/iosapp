import UIKit
import CoreData

class ViewControllerRegister: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }

    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var reenterPassTextField: UITextField!
    
    @IBAction func registerPressed(_ sender: Any) {
        checkIfFullNameEmpty()
        validateTextfields()
        let username = usernameTextField.text!
        let password = passwordTextField.text!

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
        fullNameTextField.layer.borderWidth = 1
        fullNameTextField.layer.borderColor = UIColor.gray.cgColor
        fullNameTextField.layer.cornerRadius = 5.0
        fullNameTextField.frame.size.height = 40
        mobileNumberTextField.layer.borderWidth = 1
        mobileNumberTextField.layer.borderColor = UIColor.gray.cgColor
        mobileNumberTextField.layer.cornerRadius = 5.0
        mobileNumberTextField.frame.size.height = 40
    }
}
//Get user to see if it exists
extension ViewControllerRegister {
    func userExists(username: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        
        // Add a predicate to filter by username
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let results = try context.fetch(fetchRequest)
            // Check if there is at least one result
            return !results.isEmpty
        } catch {
            print("Error fetching account: \(error)")
            return false
        }
    }
}

//For text field validation
extension ViewControllerRegister {
    
    func checkIfFullNameEmpty() {
        guard let fullName = fullNameTextField.text, !fullName.isEmpty else {
            print("Please enter your name")
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Please enter your name.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
    func validateTextfields() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Username or password is empty")
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Please enter email and password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if !username.hasSuffix("@gmail.com") {
            print("Please re-enter password")
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Username must be a valid email!",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if userExists(username: username){
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Username already exists!",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard let reenteredPass = reenterPassTextField.text, !reenteredPass.isEmpty else {
            print("Please re-enter password")
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Please re-enter your password.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        if reenteredPass != password {
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Passwords must match!",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            print("Please enter your name")
            let alertController = UIAlertController(title: "Register Failed",
                                                    message: "Please enter your mobile number.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    
}
