//
//  MusicCollectionViewCell.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/15/25.
//

import UIKit

class MusicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var songImage: UIImageView!
    
    @IBOutlet weak var songName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        songImage.layer.cornerRadius = 10
        songImage.translatesAutoresizingMaskIntoConstraints = false
        songName.translatesAutoresizingMaskIntoConstraints = false
            // Set constraints for the image view
            NSLayoutConstraint.activate([
                songImage.topAnchor.constraint(equalTo: contentView.topAnchor),
                songImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                songImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                //songImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                songImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8) // Adjust height as needed
            ])

            // Set constraints for the label
            NSLayoutConstraint.activate([
                songName.topAnchor.constraint(equalTo: songImage.bottomAnchor, constant: 8), // Space below the image
                //songName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                //songName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                songName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                songName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) // Optional
            ])
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
}
