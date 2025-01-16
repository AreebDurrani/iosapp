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
            
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    
}
