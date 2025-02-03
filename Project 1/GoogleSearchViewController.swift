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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
