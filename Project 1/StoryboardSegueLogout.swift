//
//  StoryboardSegueLogout.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class StoryboardSegueLogout: UIStoryboardSegue {
override func perform() {
        let sourceViewController = self.source
        let destinationViewController = self.destination
        destinationViewController.modalPresentationStyle = .fullScreen
        sourceViewController.present(destinationViewController, animated: true, completion: nil)
    }
}
