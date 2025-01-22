//
//  ViewControllerMusic.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/15/25.
//

import UIKit
import AVFoundation

class ViewControllerMusic: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var audioPlayer: AVAudioPlayer?
    var currentTrackIndex: (section: Int, item: Int)?
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return songsAndAudioFiles[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newMusicCell", for: indexPath) as! MusicCollectionViewCell
        /*var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = songsAndAudioFiles[indexPath.section][indexPath.item].title
        contentConfiguration.image = UIImage(named: "music")
        cell.contentConfiguration = contentConfiguration*/
        cell.songImage.image = UIImage(named: "music")
        cell.songName.text = songsAndAudioFiles[indexPath.section][indexPath.item].title
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentTrackIndex = (section: indexPath.section, item: indexPath.item)
        let audioFileName = songsAndAudioFiles[indexPath.section][indexPath.item].fileName
        playAudio(fileName: audioFileName)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    private func playAudio(fileName: String) {
        guard let audioDataAsset = NSDataAsset(name: fileName) else {
            print("Audio asset not found: \(fileName)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(data: audioDataAsset.data)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
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
        navigationController?.toolbar.tintColor = UIColor(red: 221/255, green: 232/255, blue: 10/255, alpha: 1)
        navigationController?.toolbar.isTranslucent = false
        navigationController?.isToolbarHidden = false
    }

    @objc private func playPauseAudio() {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    @objc private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }

    @objc private func nextTrack() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let nextItem = (currentTrackIndex.item + 1) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, nextItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][nextItem].fileName
        playAudio(fileName: audioFileName)
    }

    @objc private func previousTrack() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousItem = (currentTrackIndex.item - 1 + songsAndAudioFiles[currentTrackIndex.section].count) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, previousItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][previousItem].fileName
        playAudio(fileName: audioFileName)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        handleLogout()
    }
    
    
    @IBAction func textfieldChanged(_ sender: Any) {
        handleSearch()
    }
    
}

extension ViewControllerMusic {
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
