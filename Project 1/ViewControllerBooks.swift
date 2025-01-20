import UIKit
import PDFKit  // Required for PDFView, PDFDocument, etc.

class ViewControllerBooks: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var genreSegment: UISegmentedControl!
    
    @IBOutlet weak var technicalCollectionView: UICollectionView!
    @IBOutlet weak var generalCollectionView: UICollectionView!
    @IBOutlet weak var cookingCollectionView: UICollectionView!
    
    // Arrays of arrays in case you want multiple sections in the future
    var generalBooks = [[]]
    var technicalBooks = [[]]
    var cookingBooks = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load your PDF file data (filenames, titles, etc.)
        generalBooks = getGeneralBooks()
        technicalBooks = getTechnicalBooks()
        cookingBooks = getCookingBooks()
        
        // Configure layouts
        configureCollectionViewLayout()
        
        // Initially show the "General" books
        genreSegment.selectedSegmentIndex = 0
        technicalCollectionView.isHidden = true
        cookingCollectionView.isHidden = true
        
        // Set delegates & data sources
        generalCollectionView.delegate = self
        generalCollectionView.dataSource = self
        
        technicalCollectionView.delegate = self
        technicalCollectionView.dataSource = self
        
        cookingCollectionView.delegate = self
        cookingCollectionView.dataSource = self
        
        // Segment Control styling
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        genreSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        genreSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
    }
    
    // MARK: - CollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1  // We only have one section for each collection in this example
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == generalCollectionView {
            return getGeneralBooks()[section].count
        } else if collectionView == technicalCollectionView {
            return getTechnicalBooks()[section].count
        } else {
            return getCookingBooks()[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell",
                                                      for: indexPath) as! BooksCollectionViewCell
        
        // Grab the correct book
        let book = getBook(for: collectionView, at: indexPath)
        
        // Configure cell
        cell.title.text = book.title
        // Optionally display a generic book cover or any placeholder
        cell.cover.image = UIImage(named: "book")
        
        return cell
    }
    
    // MARK: - CollectionView Delegate
    
    // When user taps a book, display the PDF
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = getBook(for: collectionView, at: indexPath)
        
        // Use NSDataAsset to load PDF data from your asset catalog
        guard let pdfAsset = NSDataAsset(name: book.fileName) else {
            // Show an alert instead of printing to the console
            let alert = UIAlertController(
                title: "Error",
                message: "Could not find PDF Data Asset named \(book.fileName)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Create a PDFView with the PDF document
        let pdfView = PDFView(frame: .zero)
        pdfView.document = PDFDocument(data: pdfAsset.data)
        pdfView.autoScales = true  // Automatically scale to fit
        
        // Create a view controller to display pdfView
        let pdfViewController = UIViewController()
        pdfViewController.view.backgroundColor = .white
        pdfViewController.view.addSubview(pdfView)
        
        // Auto-layout constraints to make the PDFView fill the entire view
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: pdfViewController.view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: pdfViewController.view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: pdfViewController.view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: pdfViewController.view.bottomAnchor)
        ])
        
        // Present the PDF viewer modally
        present(pdfViewController, animated: true, completion: nil)
    }

    
    // Helper method to pick the correct array based on which collection view is tapped
    private func getBook(for collectionView: UICollectionView,
                         at indexPath: IndexPath) -> (title: String, fileName: String) {
        if collectionView == generalCollectionView {
            return getGeneralBooks()[indexPath.section][indexPath.row]
        } else if collectionView == technicalCollectionView {
            return getTechnicalBooks()[indexPath.section][indexPath.row]
        } else {
            return getCookingBooks()[indexPath.section][indexPath.row]
        }
    }
    
    // MARK: - Layout
    
    private func configureCollectionViewLayout() {
        let generalLayout = UICollectionViewFlowLayout()
        generalLayout.itemSize = CGSize(width: 100, height: 150)
        generalLayout.minimumLineSpacing = 20
        generalLayout.scrollDirection = .vertical
        
        let technicalLayout = UICollectionViewFlowLayout()
        technicalLayout.itemSize = CGSize(width: 100, height: 150)
        technicalLayout.minimumLineSpacing = 20
        technicalLayout.scrollDirection = .vertical
        
        let cookingLayout = UICollectionViewFlowLayout()
        cookingLayout.itemSize = CGSize(width: 100, height: 150)
        cookingLayout.minimumLineSpacing = 20
        cookingLayout.scrollDirection = .vertical
        
        generalCollectionView.setCollectionViewLayout(generalLayout, animated: false)
        technicalCollectionView.setCollectionViewLayout(technicalLayout, animated: false)
        cookingCollectionView.setCollectionViewLayout(cookingLayout, animated: false)
    }
    
    // MARK: - Actions
    
    @IBAction func printNum(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        generalCollectionView.isHidden = (selectedIndex != 0)
        technicalCollectionView.isHidden = (selectedIndex != 1)
        cookingCollectionView.isHidden = (selectedIndex != 2)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
}

// MARK: - Extension for Data

extension ViewControllerBooks {
    func getGeneralBooks() -> [[(title: String, fileName: String)]] {
        return [[
            ("Armageddon 2419 A.D.", "armageddon"),
            ("Test Book 2", "testbook2"),
            ("Test Book 3", "testbook3"),
            ("Test Book 4", "testbook4"),
            ("Test Book 5", "testbook5")
        ]]
    }
    
    func getCookingBooks() -> [[(title: String, fileName: String)]] {
        return [[
            ("Cheeseburger", "burger"),
            ("Pizza", "pizza"),
            ("Hot Dog", "hotdog")
        ]]
    }
    
    func getTechnicalBooks() -> [[(title: String, fileName: String)]] {
        return [[
            ("C", "clang"),
            ("C++", "cpp"),
            ("Java", "java"),
            ("Swift", "swift")
        ]]
    }
}
