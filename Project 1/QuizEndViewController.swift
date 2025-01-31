import UIKit

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
            setImage("popper")
            
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
