import UIKit
import PDFKit

class CollectionViewControllerBooks: UICollectionViewController {
    
    let books: [[(title: String, fileName: String)]] = [[
        ("Armageddon 2419 A.D.", "armageddon"), ("testBook2", "armageddon"), ("testBook3", "armageddon"),
        ("testBook4", "armageddon"), ("testBook5", "armageddon"), ("testBook6", "armageddon"),
        ("testBook7", "armageddon"), ("testBook8", "armageddon"), ("testBook9", "armageddon"),
        ("testBook10", "armageddon"), ("testBook11", "armageddon")
    ]]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionViewLayout()
    }

    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 50)
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return books.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "booksCell", for: indexPath)
        var contentConfiguration = UIListContentConfiguration.cell()
        let book = books[indexPath.section][indexPath.row]
        contentConfiguration.text = book.title
        contentConfiguration.image = UIImage(named: "book")
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

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
