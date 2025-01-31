import UIKit
import CoreData

class QuizEndViewController: UIViewController {

    var score : Int!
    
    @IBOutlet weak var congratsMessage: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(score)
        setCongratsMsgConstraints()
        setCongratsMsg()
        setImageConstraints()
        scoreLabel.text! = "\(score!)/5 questions"
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        returnButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "QuizzesViewController") as? QuizzesViewController {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setCongratsMsgConstraints(){
        congratsMessage.textAlignment = .center
        congratsMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            congratsMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            congratsMessage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 300)
        ])
    }
    
    func setCongratsMsg() {
        
        if score == 5 {
            congratsMessage.text = "Incredible!"
            if UsernameManager.shared.currentQuiz == "painter" {
                UsernameManager.shared.painterPerfect = true
            }
            else if UsernameManager.shared.currentQuiz == "mountain"{
                UsernameManager.shared.mountainPerfect = true
            }
            else{
                UsernameManager.shared.capitalPerfect = true
            }
            
            setImage("popper")
            updateCoreDataAccount()
            
        } else if score < 5 && score >= 3 {
            congratsMessage.text = "Nice!"
            setImage("thumbsup")
        } else {
            congratsMessage.text = "Oh no!"
            setImage("frowningface")
        }
    }
    

    func setImageConstraints() {
        resultImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            // Set the width and height of the image
            resultImage.widthAnchor.constraint(equalToConstant: 150), // Adjust this value
            resultImage.heightAnchor.constraint(equalToConstant: 150) // Adjust this value
        ])
    }
    
    func setImage(_ imgName : String) {
        resultImage.image = UIImage(named: imgName)
        
        // Initial scale for the "pop" effect
        resultImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // Animate the image to scale to its normal size
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn], animations: {
            self.resultImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }
}

extension QuizEndViewController {
    private func updateCoreDataAccount() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Account> = Account.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == [c] %@", UsernameManager.shared.username!)

        do {
            let results = try context.fetch(fetchRequest)
            if let account = results.first {
                let quizName = UsernameManager.shared.currentQuiz
                if quizName == "painter"{
                    print("in painter")
                    account.painterPerfect = true
                }
                else if quizName == "mountain" {
                    print("in mountain")
                    account.mountainPerfect = true
                }
                else{
                    print("in capital")
                    account.capitalPerfect = true
                }
                
                // Save the changes
                try context.save()
                print("Core Data account updated successfully")
            }
        } catch let error as NSError {
            print("Error updating account: \(error), \(error.userInfo)")
        }
    }
}
