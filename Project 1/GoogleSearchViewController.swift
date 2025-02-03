//
//  GoogleSearchViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/19/25.
//

import UIKit
import WebKit

class GoogleSearchViewController: UIViewController {

    @IBOutlet weak var googleSearchView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = createUsernameLabel().customView
        if let url = URL(string: "https://www.google.com") {
                let request = URLRequest(url: url)
            googleSearchView.load(request)
            }
        // Do any additional setup after loading the view.
    }
    

}
