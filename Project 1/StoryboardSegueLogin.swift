//
//  StoryboardSegueLogin.swift
//  Project 1
//
//  Created by Areeb Durrani on 12/30/24.
//

import UIKit

class StoryboardSegueLogin: UIStoryboardSegue {
override func perform() {
        let sourceViewController = self.source
        let destinationViewController = self.destination
        destinationViewController.modalPresentationStyle = .fullScreen
        sourceViewController.present(destinationViewController, animated: true, completion: nil)
    }
}
