//
//  QuizzesViewController.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class QuizzesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var mountainsMedal: UIImageView!
    @IBOutlet weak var capitalsMedal: UIImageView!
    @IBOutlet weak var paintersMedal: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let images = ["everest", "paris", "monalisa"]
    let titles = ["Elevation Guesser", "Capital Guesser", "Painter Guesser"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = createUsernameLabel().customView
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
        navigationController?.navigationBar.isHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        setMedals()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuizCarouselCell", for: indexPath) as! QuizCarouselCell
        let imageName = images[indexPath.item]
        cell.quizImg.image = UIImage(named: imageName) // Replace with image loading logic for URLs if needed
        cell.quizTitle.text = titles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "QuizQuestionViewController") as? QuizQuestionViewController {
            switch indexPath.row {
            case 0:
                UsernameManager.shared.currentQuiz = "mountain"
                vc.quiz = mountainQuiz
            case 1:
                UsernameManager.shared.currentQuiz = "capital"
                vc.quiz = capitalQuiz
            default:
                UsernameManager.shared.currentQuiz = "painter"
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

extension QuizzesViewController {
    func setMedals(){
        mountainsMedal.image = UIImage(named: "medal")
        capitalsMedal.image = UIImage(named: "medal")
        paintersMedal.image = UIImage(named: "medal")
        // Set default alpha for all medals
        [mountainsMedal, capitalsMedal, paintersMedal].forEach {
            $0?.alpha = 0.2
        }
        
        // Check achievements and set full alpha for unlocked ones
        if UsernameManager.shared.mountainPerfect == true {
            mountainsMedal.alpha = 1.0
        }
        
        if UsernameManager.shared.capitalPerfect! == true {
            capitalsMedal.alpha = 1.0
        }
        
        if UsernameManager.shared.painterPerfect! == true {
            paintersMedal.alpha = 1.0
        }
    }
    
}

