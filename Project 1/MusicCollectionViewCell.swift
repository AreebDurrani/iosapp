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
        // Cell & Image styling
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        songImage.layer.cornerRadius = 10
        
        // Image constraints
        songImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            songImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            songImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            songImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            songImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
        
        // Label configuration
        songName.translatesAutoresizingMaskIntoConstraints = false
        songName.textAlignment = .left       // Text aligns left within label
        songName.lineBreakMode = .byTruncatingTail  // Truncate at end
        songName.numberOfLines = 1           // Single line
        
        // Label constraints
        NSLayoutConstraint.activate([
            songName.topAnchor.constraint(equalTo: songImage.bottomAnchor, constant: 8),
            songName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),  // Center label
            songName.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 4),
            songName.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -4),
            songName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
