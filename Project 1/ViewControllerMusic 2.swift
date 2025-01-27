//
//  ViewControllerMusic.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/15/25.
//

import UIKit
import AVFoundation

class ViewControllerMusic2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var toolBarView: UIView!
    
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var audioPlayer: AVAudioPlayer?
    var player: AVPlayer?
    var currentTrackIndex: (section: Int, item: Int)?
    override func viewDidLoad() {
        super.viewDidLoad()
        disableToolBar()
        setUpToolBarView()
        fetchTracks {
                // Once fetchTracks finishes, reload the collection view with the fetched data
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        navigationItem.titleView = createUsernameLabel().customView
        if let navigationController = self.navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // Prevents transparency
            appearance.backgroundColor = UIColor.black // Set your desired background color
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        setupToolbarActions()
        configureCollectionViewLayout()
    }

    var songsAndAudioFiles: [[(title: String, fileName: String)]] = [
        [
            ("Moonlight Sonata", "moonlight_sonata"),
            ("Test Song 1", "test_song_1"),
            ("Test Song 2", "test_song_2"),
            ("Test Song 3", "test_song_3"),
            ("Test Song 4", "test_song_4")
        ]
    ]
    
    let defaultSongData: [[(title: String, fileName: String)]] = [
        [
            ("Moonlight Sonata", "moonlight_sonata"),
            ("Test Song 1", "test_song_1"),
            ("Test Song 2", "test_song_2"),
            ("Test Song 3", "test_song_3"),
            ("Test Song 4", "test_song_4")
        ]
    ]
    
    var fetchedTracks: [Track] = []

    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: view.bounds.width, height: 50)
        layout.itemSize = CGSize(width: 175, height: 200)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return songsAndAudioFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(fetchedTracks.count)
        return fetchedTracks.count
        //return songsAndAudioFiles[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newMusicCell", for: indexPath) as! MusicCollectionViewCell
        /*var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = songsAndAudioFiles[indexPath.section][indexPath.item].title
        contentConfiguration.image = UIImage(named: "music")
        cell.contentConfiguration = contentConfiguration*/
        if let imageUrl = URL(string: fetchedTracks[indexPath.item].coverImageURL) {
            UIImage.load(from: imageUrl) { image in
                if let loadedImage = image {
                    // Use the loaded image
                    cell.songImage.image = loadedImage
                } else {
                    // Handle the error case
                    print("Failed to load image")
                }
            }
        }
        //cell.songImage.image = UIImage(named: "music")
        cell.songName.text = fetchedTracks[indexPath.item].title
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentTrackIndex = (section: indexPath.section, item: indexPath.item)
        let previewURL = fetchedTracks[indexPath.item].previewURL
        playAudio(withURL: previewURL)
        enableToolBar()
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    private func playAudio(withURL urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Create the player with the URL and start playback
        player = AVPlayer(url: url)
        player?.play()
    }

    private func setupToolbarActions() {
        let playButton = UIBarButtonItem(systemItem: .play)
        playButton.target = self
        playButton.action = #selector(playPauseAudio)

        let stopButton = UIBarButtonItem(systemItem: .stop)
        stopButton.target = self
        stopButton.action = #selector(stopAudio)

        let rewindButton = UIBarButtonItem(systemItem: .rewind)
        rewindButton.target = self
        rewindButton.action = #selector(previousTrack)

        let fastForwardButton = UIBarButtonItem(systemItem: .fastForward)
        fastForwardButton.target = self
        fastForwardButton.action = #selector(nextTrack)

        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        toolbarItems = [rewindButton, flexibleSpace, playButton, flexibleSpace, stopButton, flexibleSpace, fastForwardButton]
        navigationController?.toolbar.barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        navigationController?.toolbar.tintColor = UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        navigationController?.toolbar.isTranslucent = false
        navigationController?.isToolbarHidden = true
    }

    @objc private func playPauseAudio() {
        guard let audioPlayer = player else { return }
        if player?.timeControlStatus == .playing {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    @objc private func stopAudio() {
        player?.pause()
        //player?.currentTime = 0
    }

    @objc private func nextTrack() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let nextItem = (currentTrackIndex.item + 1) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, nextItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][nextItem].fileName
        let previewURL = fetchedTracks[nextItem].previewURL
        playAudio(withURL: previewURL)
    }

    @objc private func previousTrack() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousItem = (currentTrackIndex.item - 1 + songsAndAudioFiles[currentTrackIndex.section].count) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, previousItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][previousItem].fileName
        let previewURL = fetchedTracks[previousItem].previewURL
        playAudio(withURL: previewURL)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        handleLogout()
    }
    
    
    @IBAction func textfieldChanged(_ sender: Any) {
        handleSearch()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        playButtonPressed()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        pauseButtonPressed()
    }
    
    @IBAction func forwardButtonPressed(_ sender: Any) {
        nextSong()
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        previousSong()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        stopSong()
    }
    
}

extension ViewControllerMusic2 {
    func handleLogout() {
        self.performSegue(withIdentifier: "logoutSegue", sender: self)
    }
    
    func handleSearch() {
        if searchTextField.text!.isEmpty{
            songsAndAudioFiles = defaultSongData
        }
        else{
            print(searchTextField.text!)
            songsAndAudioFiles[0] = defaultSongData[0].filter{$0.0.lowercased().hasPrefix(searchTextField.text!.lowercased())}
        }
        collectionView.reloadData()
    }
}

extension ViewControllerMusic2 {
    
    func fetchTracks(completion: @escaping () -> Void){
        fetchRockTracksWithPreview { tracks in
            for track in tracks {
                self.fetchedTracks.append(track)
                print("Track: \(track.title), Artist: \(track.artist), Preview URL: \(track.previewURL)")
            }
            completion()
        }
        
    }
}

extension ViewControllerMusic2 {
    func disableToolBar() {
        playButton.isHidden = true
        pauseButton.isHidden = true
        forwardButton.isHidden = true
        backwardButton.isHidden = true
        toolBarView.isHidden = true
        stopButton.isHidden = true
    }
    
    func enableToolBar() {
        pauseButton.isHidden = false
        forwardButton.isHidden = false
        backwardButton.isHidden = false
        toolBarView.isHidden = false
        stopButton.isHidden = false
    }
    
    func pauseButtonPressed() {
        pauseButton.isHidden = true
        playButton.isHidden = false
        guard let audioPlayer = player else { return }
        if player?.timeControlStatus == .playing {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
    func playButtonPressed() {
        pauseButton.isHidden = false
        playButton.isHidden = true
        guard let audioPlayer = player else { return }
        if player?.timeControlStatus == .playing {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
    func nextSong(){
        guard let currentTrackIndex = currentTrackIndex else { return }
        let nextItem = (currentTrackIndex.item + 1) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, nextItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][nextItem].fileName
        let previewURL = fetchedTracks[nextItem].previewURL
        playAudio(withURL: previewURL)
    }
    
    func previousSong(){
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousItem = (currentTrackIndex.item - 1 + songsAndAudioFiles[currentTrackIndex.section].count) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, previousItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][previousItem].fileName
        let previewURL = fetchedTracks[previousItem].previewURL
        playAudio(withURL: previewURL)
    }
    
    func setUpToolBarView(){
        toolBarView.layer.cornerRadius = 5
        toolBarView.layer.masksToBounds = true
    }
    
    func stopSong() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        disableToolBar()
    }
}

extension UIImage {
    // Load an image from a URL
    static func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        // Start an async task to download the image data
        URLSession.shared.dataTask(with: url) { data, response, error in
            // If the data is valid and there's no error, create the image
            if let data = data, error == nil {
                let image = UIImage(data: data)
                // Call the completion handler on the main thread
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}


