//
//  QuizQuestionViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/17/25.
//

import UIKit

class QuizQuestionViewController: UIViewController {
    
    var quiz : Quiz!
    var counter = 0
    var points = 0
    
    
    @IBOutlet weak var question: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var buttonA: UIButton!
    
    @IBOutlet weak var buttonB: UIButton!
    
    @IBOutlet weak var buttonC: UIButton!
    
    @IBOutlet weak var buttonD: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true 
        buttonA.layer.cornerRadius = 10
        buttonB.layer.cornerRadius = 10
        buttonC.layer.cornerRadius = 10
        buttonD.layer.cornerRadius = 10
        nextButton.layer.cornerRadius = 10
        changeQuestion(index: 0)
        changeAnswers(index: 0)
        nextButton.isHidden = true
        self.navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func checkAnswer(_ sender: Any) {
        let correctAnswer = quiz.questions[counter].correctAnswer
        let correctButton : UIButton!
        switch correctAnswer {
        case "A":
            correctButton = buttonA
        case "B":
            correctButton = buttonB
        case "C":
            correctButton = buttonC
        default:
            correctButton = buttonD
        }
        if sender as? UIButton == buttonA{
            print("button a pressed")
            if correctAnswer == "A" {
                handleCorrect(buttonA)
            }
            else{
                handleIncorrect(buttonA, correctButton)
            }
        }
        else if sender as? UIButton == buttonB{
            print("button b pressed")
            if correctAnswer == "B" {
                handleCorrect(buttonB)
            }
            else{
                handleIncorrect(buttonB, correctButton)
            }
        }
        
        else if sender as? UIButton == buttonC{
            print("button c pressed")
            if correctAnswer == "C" {
                handleCorrect(buttonC)
            }
            else{
                handleIncorrect(buttonC, correctButton)
            }
        }
        else{
            print("button d pressed")
            if correctAnswer == "D" {
                handleCorrect(buttonD)
            }
            else{
                handleIncorrect(buttonD, correctButton)
            }
        }
    }
    
    func handleIncorrect(_ pressedButton : UIButton, _ correctButton : UIButton){
        setAllButtonsGray()
        setAllButtonsDisabled()
        pressedButton.backgroundColor = UIColor.red
        correctButton.backgroundColor = UIColor(red: 221/225, green: 232/225, blue: 10/225, alpha: 1)
        nextButton.isHidden = false
    }
    
    func handleCorrect(_ pressedButton : UIButton){
        setAllButtonsGray()
        setAllButtonsDisabled()
        pressedButton.backgroundColor = UIColor(red: 221/225, green: 232/225, blue: 10/225, alpha: 1)
        nextButton.isHidden = false
        points += 1
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        setAllButtonsGreen()
        setAllButtonsEnabled()
        nextButton.isHidden = true
        counter += 1
        if counter < 5{
            changeQuestion(index: counter)
            changeAnswers(index: counter)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "QuizEnd") as? QuizEndViewController{
                vc.score = points
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    

}

//Extension for button settings
extension QuizQuestionViewController {
    
    func setAllButtonsGray() {
        buttonA.backgroundColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
        buttonB.backgroundColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
        buttonC.backgroundColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
        buttonD.backgroundColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1)
    }
    
    func setAllButtonsDisabled() {
        buttonA.isUserInteractionEnabled = false
        buttonB.isUserInteractionEnabled = false
        buttonC.isUserInteractionEnabled = false
        buttonD.isUserInteractionEnabled = false
    }
    
    func setAllButtonsGreen(){
        buttonA.backgroundColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1)
        buttonB.backgroundColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1)
        buttonC.backgroundColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1)
        buttonD.backgroundColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1)
    }
    
    func setAllButtonsEnabled(){
        buttonA.isUserInteractionEnabled = true
        buttonB.isUserInteractionEnabled = true
        buttonC.isUserInteractionEnabled = true
        buttonD.isUserInteractionEnabled = true
    }
    
    
}

//Extension to handle changing the question
extension QuizQuestionViewController {
    func changeQuestion(index: Int) {
        question.text! = quiz.questions[index].question
    }
    func changeAnswers(index: Int) {
        buttonA.setTitle(quiz.questions[index].answers[0], for: .normal)
        buttonB.setTitle(quiz.questions[index].answers[1], for: .normal)
        buttonC.setTitle(quiz.questions[index].answers[2], for: .normal)
        buttonD.setTitle(quiz.questions[index].answers[3], for: .normal)
    }
}
