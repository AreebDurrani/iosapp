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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(score)
        scoreLabel.text! = "\(score!)/5 questions"
        // Do any additional setup after loading the view.
    }
    

    
    

}
