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
    
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var audioPlayer: AVAudioPlayer?
    var player: AVPlayer?
    var currentTrackIndex: (section: Int, item: Int)?
    var looping : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableToolBar()
        setUpToolBarView()
        fetchTracks {
            DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        }
        navigationItem.titleView = createUsernameLabel().customView
        setNavigationBarOpaque()
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    var defaultSongData: [Track] = []
    
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
        return fetchedTracks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newMusicCell", for: indexPath) as! MusicCollectionViewCell
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

    func setNavigationBarOpaque() {
        if let navigationController = self.navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
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
    
    @IBAction func loopButtonPressed(_ sender: Any) {
        loopButtonPressed()
    }
}






