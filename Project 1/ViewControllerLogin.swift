import UIKit
import CoreData

class ViewControllerLogin: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    var keychainUsername : String?
    var keychainPass : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        handleFieldsFillout()
        
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
            
                handleRememberMe(rememberSwitch: rememberMeSwitch)
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                feedbackGenerator.impactOccurred()
                
                let alertController = UIAlertController(title: "Login Successful",
                                                        message: "Welcome back, \(usernameInput)!",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                self.navigationController?.setViewControllers([vc], animated: true)*/
                //self.performSegue(withIdentifier: "loginSegue", sender: self)
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
//handle text field ui
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

//handle keychain remember me
extension ViewControllerLogin {
    func handleRememberMe(rememberSwitch: UISwitch){
        let curUsername = usernameTextField.text!
        let wasReceived = receiveUsernameFromKeychain()
        usernameTextField.text! = curUsername
        if rememberMeSwitch.isOn == true{
            if wasReceived == false {
                addUserNameInKeychain()
                addPasswordInKeychain()
            }
            else{
                updateUserNameInKeychain()
                updatePasswordInkeychain()
            }
        }
        else {
            if wasReceived == true {
                if let unwrappedUsername = keychainUsername{
                    if unwrappedUsername == usernameTextField.text!{
                        deleteUsernameFromKeychain()
                        deletePasswordFromKeychain()
                    }
                }
            }
        }
    }
    
    func handleFieldsFillout() {
        receiveUsernameFromKeychain()
        receivePasswordFromKeychain()
    }
    
    func addUserNameInKeychain() {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "username",
            kSecValueData as String: usernameTextField.text!.data(using: .utf8)!]
        if SecItemAdd(attributes as CFDictionary, nil) == errSecSuccess{
            print("username added succesfully")
        }
        else{
            print("username not added")
        }
    }
    
    func addPasswordInKeychain() {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "password",
            kSecValueData as String: passwordTextField.text!.data(using: .utf8)!]
        if SecItemAdd(attributes as CFDictionary, nil) == errSecSuccess{
            print("pass added succesfully")
        }
        else{
            print("pass not added")
        }
    }
    
    func updateUserNameInKeychain(){
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "username"]
        let attributes: [String: Any] = [
            kSecValueData as String: usernameTextField.text!.data(using: .utf8)!
        ]
        print(usernameTextField.text!)
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if  status == errSecSuccess{
            print("username saved succesfully in keychain")
        }
        else{
            print("username not saved in keychain \(status)")
        }
        
    }
    
    func updatePasswordInkeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "password"]
        let attributes: [String: Any] = [
            kSecValueData as String: passwordTextField.text!.data(using: .utf8)!
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if  status == errSecSuccess{
            print("password saved succesfully in keychain")
        }
        else{
            print("password not saved in keychain \(status)")
        }
    }
    
    func receiveUsernameFromKeychain() -> Bool{
        let request : [String : Any] = [kSecClass as String : kSecClassGenericPassword,
                                        kSecAttrAccount as String : "username",
                                        kSecReturnAttributes as String : true,
                                        kSecReturnData as String : true]
        var response : CFTypeRef?
        
        if SecItemCopyMatching(request as CFDictionary, &response) == noErr {
            let data = response as? [String: Any]
            let userKey = data?[kSecAttrAccount as String] as? String
            let receivedUser = (data![kSecValueData as String] as? Data)!
            var receivedUserStr = String(data: receivedUser, encoding: .utf8)
            print(receivedUserStr)
            usernameTextField.text! = receivedUserStr!
            keychainUsername = receivedUserStr!
            return true
        }
        else{
            print("no saved username detected")
            return false
        }
    }
    
    func receivePasswordFromKeychain() -> Bool {
        let request : [String : Any] = [kSecClass as String : kSecClassGenericPassword,
                                        kSecAttrAccount as String : "password",
                                        kSecReturnAttributes as String : true,
                                        kSecReturnData as String : true]
        var response : CFTypeRef?
        
        if SecItemCopyMatching(request as CFDictionary, &response) == noErr {
            let data = response as? [String: Any]
            let passKey = data?[kSecAttrAccount as String] as? String
            let pass = (data![kSecValueData as String] as? Data)!
            var passStr = String(data: pass, encoding: .utf8)
            print(passStr)
            passwordTextField.text! = passStr!
            keychainPass = passStr!
            return true
        }
        else{
            print("no saved password detected")
            return false
        }
    }
    
    func deleteUsernameFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "username"]
        let status = SecItemDelete(query as CFDictionary)
        if  status == errSecSuccess{
            print("username deleted succesfully in keychain")
        }
        else{
            print("username not deleted in keychain \(status)")
        }
    }
    
    func deletePasswordFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "password"]
        let status = SecItemDelete(query as CFDictionary)
        if  status == errSecSuccess{
            print("password deleted succesfully in keychain")
        }
        else{
            print("password not deleted in keychain \(status)")
        }
    }
}
