//
//  MainViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/15/25.
//

import UIKit

class MainTabController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor(red: 183/255, green: 183/255, blue: 183/255, alpha: 1)// Customize this color
        appearance.backgroundColor = UIColor(named: "BackgroundColor")
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.barTintColor = UIColor.black
        tabBar.isTranslucent = false

        // Set the color for the selected tab
        tabBar.tintColor = UIColor(named: "greenbuttons") // Customize this color

        // Set the color for the unselected tabs
        tabBar.unselectedItemTintColor = UIColor.lightGray // Customize this color
        for viewController in self.viewControllers ?? [] {
                    viewController.view.backgroundColor = UIColor.black // Set consistent background color
                }
    }
    

}
