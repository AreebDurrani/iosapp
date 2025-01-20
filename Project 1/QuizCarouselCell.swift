//
//  QuizCarouselCell.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/19/25.
//

import UIKit

class QuizCarouselCell: UICollectionViewCell {
    
    @IBOutlet weak var quizImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        quizImg.layer.cornerRadius = 10
        // Disable autoresizing masks to use Auto Layout
        quizImg.translatesAutoresizingMaskIntoConstraints = false

        // Pin the image view to the edges of the cell
        NSLayoutConstraint.activate([
            quizImg.topAnchor.constraint(equalTo: contentView.topAnchor),
            quizImg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quizImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quizImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        quizImg.contentMode = .scaleAspectFill
        quizImg.clipsToBounds = true
    }
}
