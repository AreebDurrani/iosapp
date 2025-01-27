//
//  QuizCarouselCell.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/19/25.
//

import UIKit

class QuizCarouselCell: UICollectionViewCell {
    
    @IBOutlet weak var quizImg: UIImageView!
    
    @IBOutlet weak var quizTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        quizImg.layer.cornerRadius = 5
        // Disable autoresizing masks to use Auto Layout
        quizImg.translatesAutoresizingMaskIntoConstraints = false

        // Pin the image view to the edges of the cell
        NSLayoutConstraint.activate([
            quizImg.topAnchor.constraint(equalTo: contentView.topAnchor),
            //quizImg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            quizImg.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            quizImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            quizImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        quizTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quizTitle.topAnchor.constraint(equalTo: quizImg.bottomAnchor, constant: 8), // Space below the image
            //songName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            //songName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            quizTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            quizTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // Optional
        ])
        quizImg.contentMode = .scaleAspectFill
        quizImg.clipsToBounds = true
    }
}
