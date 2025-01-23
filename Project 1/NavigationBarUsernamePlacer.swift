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
    label.text = UsernameManager.shared.username
    label.textColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1) // Set the label's color
    label.font = UIFont.systemFont(ofSize: 17) // Set the label's font

    // Create a UIBarButtonItem with the custom label
    let labelBarButtonItem = UIBarButtonItem(customView: label)

    return labelBarButtonItem
}

