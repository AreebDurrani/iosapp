//
//  NotesCollectionViewCell.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/16/25.
//

import UIKit

class NotesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var noteText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        noteText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteText.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8), // Padding from the top
            noteText.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8), // Padding from the bottom
            noteText.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor), // Center horizontally in the contentView
            noteText.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),  // Center vertically in the contentView
            noteText.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 8), // Maintain padding
            noteText.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -8) // Maintain padding
        ])
    }
    
    
}
