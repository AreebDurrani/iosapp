//
//  QuizAndQuestionsStructs.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/19/25.
//

import Foundation

struct Quiz{
    var questions : [QuizQuestion]
    init(questions : [QuizQuestion]){
        self.questions = questions
    }
}

struct QuizQuestion{
    var correctAnswer : String
    var question : String
    var answers: [String]
    init(correctAnswer : String, question : String, answers : [String]){
        self.correctAnswer = correctAnswer
        self.question = question
        self.answers = answers
    }
    
    func isCorrect(_ answer : String) -> Bool{
        return answer == correctAnswer
    }
}
