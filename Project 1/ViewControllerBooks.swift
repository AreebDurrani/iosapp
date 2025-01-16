//
//  ViewControllerBooks.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class ViewControllerBooks: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    
    

    @IBOutlet weak var genreSegment: UISegmentedControl!
    
    @IBOutlet weak var technicalCollectionView: UICollectionView!
    @IBOutlet weak var generalCollectionView: UICollectionView!
    @IBOutlet weak var cookingCollectionView: UICollectionView!
    
    var generalBooks = [[]]
    var technicalBooks = [[]]
    var cookingBooks = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generalBooks = getGeneralBooks()
        technicalBooks = getTechnicalBooks()
        cookingBooks = getCookingBooks()
        
        configureCollectionViewLayout()
        
        genreSegment.selectedSegmentIndex = 0
        technicalCollectionView.isHidden = true
        cookingCollectionView.isHidden = true
        
        
        
        generalCollectionView.delegate = self
        generalCollectionView.dataSource = self
        technicalCollectionView.delegate = self
        technicalCollectionView.dataSource = self
        cookingCollectionView.delegate = self
        cookingCollectionView.dataSource = self
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == generalCollectionView {
            return getGeneralBooks()[section].count
        }
        else if collectionView == technicalCollectionView {
            return getTechnicalBooks()[section].count
        }
        else{
            return getCookingBooks()[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BooksCollectionViewCell
                
        if collectionView == generalCollectionView {
            let book = getGeneralBooks()[indexPath.section][indexPath.row]
            cell.title.text = book.title
            cell.cover.image = UIImage(named: "book")
        }
        else if collectionView == technicalCollectionView {
            let book = getTechnicalBooks()[indexPath.section][indexPath.row]
            cell.title.text = book.title
            cell.cover.image = UIImage(named: "book")
        }
        else {
            let book = getCookingBooks()[indexPath.section][indexPath.row]
            cell.title.text = book.title
            cell.cover.image = UIImage(named: "book")
        }
                
        return cell
    }
    
    private func configureCollectionViewLayout() {
        let generalLayout = UICollectionViewFlowLayout()
        generalLayout.itemSize = CGSize(width: 100, height: 150)
        generalLayout.minimumLineSpacing = 20
        generalLayout.scrollDirection = .vertical
        let technicalLayout = UICollectionViewFlowLayout()
        technicalLayout.itemSize = CGSize(width: 100, height: 150)
        technicalLayout.minimumLineSpacing = 20
        technicalLayout.scrollDirection = .vertical
        let cookingLayout = UICollectionViewFlowLayout()
        cookingLayout.itemSize = CGSize(width: 100, height: 150)
        cookingLayout.minimumLineSpacing = 20
        cookingLayout.scrollDirection = .vertical
        generalCollectionView.setCollectionViewLayout(generalLayout, animated: false)
        technicalCollectionView.setCollectionViewLayout(technicalLayout, animated: false)
        cookingCollectionView.setCollectionViewLayout(cookingLayout, animated: false)
    }
    
    
    @IBAction func printNum(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        generalCollectionView.isHidden = selectedIndex != 0
        technicalCollectionView.isHidden = selectedIndex != 1
        cookingCollectionView.isHidden = selectedIndex != 2
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
}

extension ViewControllerBooks {
    func getGeneralBooks() -> [[(title: String, fileName: String)]] {
        return [[
            ("Armageddon 2419 A.D.", "armageddon"), ("testBook2", "armageddon"), ("testBook3", "armageddon"),
            ("testBook4", "armageddon"), ("testBook5", "armageddon"), ("testBook6", "armageddon"),
            ("testBook7", "armageddon"), ("testBook8", "armageddon"), ("testBook9", "armageddon"),
            ("testBook10", "armageddon"), ("testBook11", "armageddon")
        ]]
    }
    
    func getCookingBooks() -> [[(title: String, fileName: String)]] {
        return [[
            ("Cheeseburger", "burger"), ("Pizza", "pizza"), ("Hot Dog", "hotdog"),
        ]]
    }
    
    func getTechnicalBooks() -> [[(title: String, fileName: String)]] {
        return [[
            ("C", "armageddon"), ("C++", "armageddon"), ("Java", "armageddon"), ("Swift", "armageddon"),
        ]]
    }
}
