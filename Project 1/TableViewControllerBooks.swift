//
//  TableViewControllerBooks.swift
//  Project 1
//
//  Created by Areeb Durrani on 12/28/24.
//

import UIKit

class TableViewControllerBooks: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Data Array for Table View
    let books : [[String]] = [["Book 1", "Book 2", "Book 3", "Book 4",  "Book 5"]]
    
    //Create sections based on the length of the data array
    override func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    //Create row based on the length of the section subarray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books[section].count
    }
    
    //Fill cell text based on the data array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        cell.textLabel?.text = books[indexPath.section][indexPath.row]
        return cell
    }
}
