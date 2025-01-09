import UIKit
import PDFKit

class TableViewControllerBooks: UITableViewController {
    
    let books: [[(title: String, fileName: String)]] = [[
        ("Armageddon 2419 A.D.", "armageddon"), ("testBook2", "armageddon"), ("testBook3", "armageddon"), ("testBook4", "armageddon"), ("testBook5", "armageddon"), ("testBook6", "armageddon"), ("testBook7", "armageddon"), ("testBook8", "armageddon"), ("testBook9", "armageddon"), ("testBook10", "armageddon"), ("testBook11", "armageddon")
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "booksCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        let book = books[indexPath.section][indexPath.row]
        contentConfiguration.text = book.title
        contentConfiguration.image = UIImage(named: "book")
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedBook = books[indexPath.section][indexPath.row]
        let pdfViewController = PDFViewController()
        pdfViewController.pdfFileName = selectedBook.fileName

        navigationController?.pushViewController(pdfViewController, animated: true)
    }
}

class PDFViewController: UIViewController {

    var pdfFileName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        view.addSubview(pdfView)

        if let pdfFileName = pdfFileName,
           let pdfDataAsset = NSDataAsset(name: pdfFileName) {
            if let pdfDocument = PDFDocument(data: pdfDataAsset.data) {
                pdfView.document = pdfDocument
            } else {
                showAlert(message: "Failed to load PDF document.")
            }
        } else {
            showAlert(message: "PDF file not found.")
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

