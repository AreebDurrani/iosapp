//
//  TableViewControllerMusic.swift
//  Project 1
//
//  Created by Areeb Durrani on 12/28/24.
//

import UIKit

class TableViewControllerMusic: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Data Array for Table View
    let songs : [[String]] = [["Song 1", "Song 2", "Song 3", "Song 4",  "Song 5"]]
    
    //Create sections based on the length of the data array
    override func numberOfSections(in tableView: UITableView) -> Int {
        return songs.count
    }
    
    //Create row based on the length of the section subarray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs[section].count
    }
    
    //Fill cell text based on the data array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = songs[indexPath.section][indexPath.row]
        contentConfiguration.image = UIImage(named: "Tux")
        cell.contentConfiguration = contentConfiguration
        return cell
    }
}
