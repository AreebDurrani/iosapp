//
//  MainViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/15/25.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)// Customize this color
        appearance.backgroundColor = UIColor.black
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        // Set the color for the selected tab
        tabBar.tintColor = UIColor.green // Customize this color

        // Set the color for the unselected tabs
        tabBar.unselectedItemTintColor = UIColor.lightGray // Customize this color
    }
    

    

}
