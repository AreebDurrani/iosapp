//
//  ViewControllerMusic.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/15/25.
//

import UIKit
import AVFoundation

class ViewControllerMusic2: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var songProgressView: UISlider!
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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        navigationItem.titleView = createUsernameLabel().customView
        setNavigationBarOpaque()
        setupSliderTarget()
        configureProgressSlider()
        collectionView.delegate = self
        collectionView.dataSource = self
        configureCollectionViewLayout()
        loopButton.tintColor = UIColor.gray
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
    
    var timeObserverToken: Any?
    
    var isSliding = false
    
    var loopSong = false

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
    
    private func setupSliderTarget() {
            // Add target for value changes
            songProgressView.addTarget(
                self,
                action: #selector(handleSliderChange(_:)),
                for: .valueChanged
            )
        }
        
    @objc private func handleSliderChange(_ sender: UISlider) {
        guard let player = player else { return }
        
        if sender.isTracking {
            // User is actively dragging
            isSliding = true
        } else {
            // User released the thumb
            let duration = player.currentItem?.duration.seconds ?? 0
            let seekTime = CMTime(
                seconds: Double(sender.value) * duration,
                preferredTimescale: 1000
            )
            player.seek(to: seekTime)
            isSliding = false
        }
    }
    
    private func configureProgressSlider() {
        // Create custom thumb image
        let thumbSize: CGFloat = 12 // Diameter of the circle
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 20, height: 20))
        
        let thumbImage = renderer.image { ctx in
            let circleFrame = CGRect(
                x: (20 - thumbSize)/2,
                y: (20 - thumbSize)/2,
                width: thumbSize,
                height: thumbSize
            )
            
            // Customize the circle appearance
            UIColor.white.setFill()
            UIBezierPath(ovalIn: circleFrame).fill()
        }
        
        // Set for both normal and highlighted states
        songProgressView.setThumbImage(thumbImage, for: .normal)
        songProgressView.setThumbImage(thumbImage, for: .highlighted)
        
        // Rest of your slider configuration
        songProgressView.minimumTrackTintColor = .systemBlue
        songProgressView.maximumTrackTintColor = .lightGray.withAlphaComponent(0.3)
    }

    func setNavigationBarOpaque() {
        if let navigationController = self.navigationController {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(named: "BackgroundColor")
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
        }
    }

    
    @IBAction func logoutPressed(_ sender: Any) {
        stopSong()
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
    
    @IBAction func loopButtonPressed(_ sender: UIButton) {
        switchLoop(sender)
    }
}






