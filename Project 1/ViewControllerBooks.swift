import UIKit
import WebKit  // for WKWebView

class ViewControllerBooks: UIViewController,
                          UICollectionViewDelegate,
                          UICollectionViewDataSource,
                          WKNavigationDelegate  // <-- Added here
{
    @IBOutlet weak var genreSegment: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var booksCollectionView: UICollectionView!
    
    struct Book: Decodable {
        let title: String
        let htmlURL: String
        let coverURL: String
    }

    // A dictionary from genre-name => array of Book objects
    typealias BooksByGenre = [String: [Book]]

    // This will hold the original data from the local JSON
    private var booksByGenre: BooksByGenre = [:]
    
    // This will be our filtered data (e.g. after search)
    private var filteredBooksByGenre: BooksByGenre = [:]
    
    // A list of genre names (e.g. ["general", "technical", "cooking", "fantasy"])
    private var genres: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegates & data sources
        booksCollectionView.delegate   = self
        booksCollectionView.dataSource = self
        
        // Configure initial layout
        configureCollectionViewLayout()
        navigationItem.titleView = createUsernameLabel().customView
        
        // Customize the segmented control text color
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "textColor") ?? .white
        ]
        genreSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        genreSegment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        // Load the local JSON
        loadLocalJSON()
    }
    
    // MARK: - Load Local JSON
    private func loadLocalJSON() {
        // 1) Find the books.json in your app bundle
        guard let fileURL = Bundle.main.url(forResource: "books", withExtension: "json") else {
            print("Could not find books.json in the main bundle.")
            return
        }
        
        do {
            // 2) Load data & decode
            let data = try Data(contentsOf: fileURL)

            let allBooks = try JSONDecoder().decode(BooksByGenre.self, from: data)
            
            // 3) Store and set up
            self.booksByGenre = allBooks
            self.filteredBooksByGenre = allBooks  // initially unfiltered
            self.genres = Array(allBooks.keys).sorted()  // e.g. ["cooking","fantasy","general","technical"]
            
            // 4) Build segmented control with these genre names
            genreSegment.removeAllSegments()
            for (index, genreName) in genres.enumerated() {
                genreSegment.insertSegment(withTitle: genreName.capitalized,
                                           at: index,
                                           animated: false)
            }
            
            // 5) Default selection to first genre (if any)
            if !genres.isEmpty {
                genreSegment.selectedSegmentIndex = 0
            }
            
            // 6) Reload collection
            booksCollectionView.reloadData()
        } catch {
            print("Error decoding local JSON file:", error)
        }
    }
    
    // MARK: - Actions
    
    // Switch the visible genre based on the selected segment
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        booksCollectionView.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        handleLogout()
    }
    
    @IBAction func textFieldChanged(_ sender: Any) {
        handleSearch()
    }
    
    // MARK: - Search Logic
    // Filters the books within the currently selected genre
    private func handleSearch() {
        guard !genres.isEmpty else { return }
        
        let query = searchTextField.text?.lowercased() ?? ""
        
        // If the search is empty, revert to original
        if query.isEmpty {
            filteredBooksByGenre = booksByGenre
        } else {
            // Otherwise, filter each genre’s books
            var newFiltered: BooksByGenre = [:]
            
            for (genreName, booksArray) in booksByGenre {
                let filteredArray = booksArray.filter {
                    $0.title.lowercased().hasPrefix(query)
                }
                newFiltered[genreName] = filteredArray
            }
            
            filteredBooksByGenre = newFiltered
        }
        
        booksCollectionView.reloadData()
    }
    
    private func handleLogout() {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    // MARK: - CollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // We’re only using one section total
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard !genres.isEmpty else { return 0 }
        
        // Determine which genre is selected
        let selectedIndex = genreSegment.selectedSegmentIndex
        let selectedGenre = genres[selectedIndex]  // e.g. "general" or "cooking"
        
        // Return the count for that genre
        return filteredBooksByGenre[selectedGenre]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell",
                                                          for: indexPath) as! BooksCollectionViewCell
            
            // Find the selected genre
            let selectedIndex = genreSegment.selectedSegmentIndex
            let selectedGenre = genres[selectedIndex]
            
            // Get the book for that row
            if let booksArray = filteredBooksByGenre[selectedGenre] {
                let book = booksArray[indexPath.row]
                
                // Configure the cell title
                cell.title.text = book.title
                
                // 2) Load the AVIF image
                if let url = URL(string: book.coverURL) {
                    // Use async/await (iOS 15+) or a background thread with completion
                    Task {
                        do {
                            // Fetch data from the cover URL
                            let (data, _) = try await URLSession.shared.data(from: url)
                            
                            // Convert data to UIImage
                            if let image = UIImage(data: data) {
                                // Update UI on the main thread
                                DispatchQueue.main.async {
                                    cell.cover.image = image
                                }
                            } else {
                                // Fallback image if decoding fails
                                DispatchQueue.main.async {
                                    cell.cover.image = UIImage(named: "book")
                                }
                            }
                        } catch {
                            // Fallback if request fails
                            DispatchQueue.main.async {
                                cell.cover.image = UIImage(named: "book")
                            }
                        }
                    }
                } else {
                    // If URL is invalid, just use a fallback
                    cell.cover.image = UIImage(named: "book")
                }
            }
            
            return cell
        }
    
    // MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedIndex = genreSegment.selectedSegmentIndex
        let selectedGenre = genres[selectedIndex]
        guard let booksArray = filteredBooksByGenre[selectedGenre] else { return }
        
        let book = booksArray[indexPath.row]
        
        guard let url = URL(string: book.htmlURL) else {
            let alert = UIAlertController(
                title: "Invalid URL",
                message: "Could not create a valid URL from: \(book.htmlURL)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        
        let webViewController = UIViewController()
        webViewController.view.backgroundColor = .white
        webViewController.view.addSubview(webView)
        webViewController.title = book.title  // Set the title of the new screen
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: webViewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: webViewController.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: webViewController.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewController.view.bottomAnchor)
        ])
        
        // Push the webViewController onto the navigation stack
        navigationController?.pushViewController(webViewController, animated: true)
    }

    

    // MARK: - WKNavigationDelegate
    
    // Once the page has loaded, inject JS to remove any "Back to Ebook" links
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = """
        document.querySelectorAll('a').forEach(function(link) {
            if (link.textContent.includes('Back to ebook') || link.textContent.includes('Standard Ebooks')) {
                link.remove();
            }
        });
        """
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    // MARK: - Layout
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        
        booksCollectionView.setCollectionViewLayout(layout, animated: false)
    }
}
