//
//  UsernameManager.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/23/25.
//

import Foundation

class UsernameManager {
    static let shared = UsernameManager()
    
    var userFullName : String?
    var username : String?
    var mountainPerfect : Bool?
    var painterPerfect : Bool?
    var capitalPerfect : Bool?
    var currentQuiz : String?
    
    private init(){}
}
