//
//  ViewControllerBooks.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/13/25.
//

import UIKit

class ViewControllerBooks: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarField: UISearchBar!
    
    var books: [[(title: String, fileName: String)]] = [[
        ("Armageddon 2419 A.D.", "armageddon"), ("testBook2", "armageddon"), ("testBook3", "armageddon"), ("testBook4", "armageddon"), ("testBook5", "armageddon"), ("testBook6", "armageddon"), ("testBook7", "armageddon"), ("testBook8", "armageddon"), ("testBook9", "armageddon"), ("testBook10", "armageddon"), ("testBook11", "armageddon")
    ]]
    
    let defaultBooks: [[(title: String, fileName: String)]] = [[
        ("Armageddon 2419 A.D.", "armageddon"), ("testBook2", "armageddon"), ("testBook3", "armageddon"), ("testBook4", "armageddon"), ("testBook5", "armageddon"), ("testBook6", "armageddon"), ("testBook7", "armageddon"), ("testBook8", "armageddon"), ("testBook9", "armageddon"), ("testBook10", "armageddon"), ("testBook11", "armageddon")
    ]]

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        let book = books[indexPath.section][indexPath.row]
        contentConfiguration.text = book.title
        contentConfiguration.image = UIImage(named: "book")
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedBook = books[indexPath.section][indexPath.row]
        let pdfViewController = PDFViewController()
        pdfViewController.pdfFileName = selectedBook.fileName

        navigationController?.pushViewController(pdfViewController, animated: true)
    }
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        let vc = UIStoryboard.init(name:"Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewControllerLogin")
        self.navigationController?.setViewControllers([vc], animated:true)
    }
    
}

extension ViewControllerBooks : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String){
        if searchText.isEmpty{
            books = defaultBooks
        }
        else{
            books[0] = defaultBooks[0].filter{$0.0.hasPrefix(searchText)}
        }
        tableView.reloadData()
    }
}
