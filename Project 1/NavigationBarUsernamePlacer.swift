//
//  NavigationBarUsernamePlacer.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/23/25.
//

import Foundation
import UIKit
func createUsernameLabel() -> UIBarButtonItem {
    let label = UILabel()
    label.text = UsernameManager.shared.userFullName
    label.textColor = UIColor(named: "textColor") // Set the label's color
    label.font = UIFont.boldSystemFont(ofSize: 19) // Set the label's font
    

    // Create a UIBarButtonItem with the custom label
    let labelBarButtonItem = UIBarButtonItem(customView: label)

    return labelBarButtonItem
}

