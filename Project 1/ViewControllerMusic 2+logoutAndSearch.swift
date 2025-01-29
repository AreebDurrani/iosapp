//
//  ViewControllerMusic 2+logout.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/29/25.
//

import Foundation

extension ViewControllerMusic2 {
    func handleLogout() {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func handleSearch() {
        if searchTextField.text!.isEmpty{
            fetchedTracks = defaultSongData
        }
        else{
            print(searchTextField.text!)
            fetchedTracks = defaultSongData.filter{$0.title.lowercased().hasPrefix(searchTextField.text!.lowercased())}
        }
        collectionView.reloadData()
    }
}
