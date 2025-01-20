//
//  MountainQuiz.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/19/25.
//

import Foundation

struct MountainQuizQuestions {
    let question1 = QuizQuestion(correctAnswer: "B", question: "What is the height of Mt. Everest?", answers: ["36,823 ft", "29,032 ft", "12,746 ft", "18,924 ft"])
    let question2 = QuizQuestion(correctAnswer: "D", question: "What is the height of Mt. Fuji?", answers: ["16,381 ft", "22,054 ft", "24,360 ft", "12,388 ft"])
    let question3 = QuizQuestion(correctAnswer: "A", question: "What is the height of Mt. Kiliamanjaro?", answers: ["19,341 ft", "39,465 ft", "13,967 ft", "27,923 ft"])
    let question4 = QuizQuestion(correctAnswer: "C", question: "What is the height of Mt. Rainier?", answers: ["13,026 ft", "12,495 ft", "14,411 ft", "16,823 ft"])
    let question5 = QuizQuestion(correctAnswer: "D", question: "What is the height of Mt. Matterhorn?", answers: ["11,423 ft", "15,496 ft", "12,295 ft", "14,692 ft"])
    
    func getQuestions() -> [QuizQuestion] {
        return [question1, question2, question3, question4, question5]
    }
}

struct CapitalQuizQuestions {
    let question1 = QuizQuestion(correctAnswer: "B", question: "What is the capital of the United States of America?", answers: ["Phoenix", "Washington D.C", "Los Angeles", "New York"])
    let question2 = QuizQuestion(correctAnswer: "C", question: "What is the capital of China?", answers: ["Shanghai", "Chengdu", "Beijing", "Linyi"])
    let question3 = QuizQuestion(correctAnswer: "A", question: "What is the capital of Canada?", answers: ["Ottawa", "Toronto", "Montreal", "Vancouver"])
    let question4 = QuizQuestion(correctAnswer: "D", question: "What is the capital of France?", answers: ["Nantes", "Marseille", "Lyon", "Paris"])
    let question5 = QuizQuestion(correctAnswer: "B", question: "What is the capital of Germany?", answers: ["Munich", "Berlin", "Hamburg", "Dresden"])
    func getQuestions() -> [QuizQuestion] {
        return [question1, question2, question3, question4, question5]
    }
}

struct PaintingQuizQuestions {
    let question1 = QuizQuestion(correctAnswer: "A", question: "Who painted 'Starry Night'?", answers: ["Vincent van Gogh", "Claude Monet", "Rembrandt", "Hagia Sophia"])
    let question2 = QuizQuestion(correctAnswer: "B", question: "Who painted 'Mona Lisa'?", answers: ["Pablo Picasso", "Leonardo da Vinci", "Vincent van Gogh", " Michelangelo"])
    let question3 = QuizQuestion(correctAnswer: "D", question: "Which artist is famous for painting melting clocks?", answers: ["Jackson Pollock", "Andy Warhol", "Pablo Picasso", "Salvador Dalí"])
    let question4 = QuizQuestion(correctAnswer: "A", question: "Who sculpted the famous statue of David?", answers: ["Michelangelo", "Donatello", "Leonardo da Vinci", "Raphael"])
    let question5 = QuizQuestion(correctAnswer: "B", question: "Which artist is known for his series of paintings depicting water lilies?", answers: ["Édouard Manet", "Claude Monet", "Pierre-Auguste Renoir", "Paul Cézanne"])
    func getQuestions() -> [QuizQuestion] {
        return [question1, question2, question3, question4, question5]
    }
}

let mountainQuiz = Quiz(questions: MountainQuizQuestions().getQuestions())
let capitalQuiz = Quiz(questions: CapitalQuizQuestions().getQuestions())
let painterQuiz = Quiz(questions: PaintingQuizQuestions().getQuestions())

