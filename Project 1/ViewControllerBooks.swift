//
//  ViewControllerBooks.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class ViewControllerBooks: UIViewController {

    @IBOutlet weak var genreSegment: UISegmentedControl!
    
    @IBOutlet weak var technicalCollectionView: UICollectionView!
    @IBOutlet weak var generalCollectionView: UICollectionView!
    
    @IBOutlet weak var cookingCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        genreSegment.selectedSegmentIndex = 0
        technicalCollectionView.isHidden = true
        cookingCollectionView.isHidden = true
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white, // Unselected color
            //.font: UIFont.systemFont(ofSize: 14)
        ]
        genreSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)

        // Set text color for selected state
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, // Selected color
            //.font: UIFont.boldSystemFont(ofSize: 14)
        ]
        genreSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func printNum(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        generalCollectionView.isHidden = selectedIndex != 0
        technicalCollectionView.isHidden = selectedIndex != 1
        cookingCollectionView.isHidden = selectedIndex != 2
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
