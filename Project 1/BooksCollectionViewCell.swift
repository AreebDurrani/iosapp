//
//  BooksCollectionViewCell.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class BooksCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var cover: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        cover.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
            // Set constraints for the image view
            NSLayoutConstraint.activate([
                cover.topAnchor.constraint(equalTo: contentView.topAnchor),
                cover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                cover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                //songImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                cover.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8) // Adjust height as needed
            ])

            // Set constraints for the label
            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 8), // Space below the image
                //title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                //title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // Optional
            ])
        }
}
