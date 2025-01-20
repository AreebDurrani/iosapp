//
//  QuizzesViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class QuizzesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let images = ["everest", "paris", "monalisa"] // Replace with your image names

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the collection view
        collectionView.delegate = self
        collectionView.dataSource = self

        // Register the custom cell
        //collectionView.register(UINib(nibName: "QuizCarouselCell", bundle: nil), forCellWithReuseIdentifier: "QuizCarouselCell")
        
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: view.bounds.width, height: 50)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: collectionView.frame.height)
        collectionView.collectionViewLayout = layout
        /*let leftInset = (collectionView.frame.width - 175) / 2 // Assuming item width is 175
        collectionView.contentInset = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)*/

    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCarouselCell", for: indexPath) as! QuizCarouselCell
        let imageName = images[indexPath.item]
        cell.quizImg.image = UIImage(named: imageName) // Replace with image loading logic for URLs if needed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "QuizQuestionViewController") as? QuizQuestionViewController {
            switch indexPath.row {
            case 0:
                vc.quiz = mountainQuiz
            case 1:
                vc.quiz = capitalQuiz
            default:
                vc.quiz = painterQuiz
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: view.bounds.width, height: 50)
        layout.itemSize = CGSize(width: 175, height: 200)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
}


