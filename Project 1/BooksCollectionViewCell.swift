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
        
        // Cell & ContentView Setup
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        // ImageView Constraints
        cover.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cover.topAnchor.constraint(equalTo: contentView.topAnchor),
            cover.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cover.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cover.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        // Label Configuration
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .left // Text starts from the left
        title.lineBreakMode = .byTruncatingTail // Truncate at the end
        title.numberOfLines = 1 // Force single line
        
        // Label Constraints
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: cover.bottomAnchor, constant: 8),
            title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor), // Center the label
            title.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 4), // Prevent overflow left
            title.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -4), // Prevent overflow right
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
}
