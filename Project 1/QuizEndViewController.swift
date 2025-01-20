//
//  QuizEndViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/19/25.
//

import UIKit

class QuizEndViewController: UIViewController {

    var score : Int!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var returnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(score)
        scoreLabel.text! = "\(score!)/5 questions"
        tabBarController?.tabBar.isHidden = true
        returnButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "QuizzesViewController") as? QuizzesViewController {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    

}
