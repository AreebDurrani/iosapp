//
//  ViewControllerMusic.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/13/25.
//

import UIKit
import AVFoundation

class ViewControllerMusic: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBarField: UISearchBar!
    var audioPlayer: AVAudioPlayer?
    var currentTrackIndex: (section: Int, row: Int)?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        setupToolbarActions()
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
    
    let defaultSongsAndAudioFiles: [[(title: String, fileName: String)]] = [
        [
            ("Moonlight Sonata", "moonlight_sonata"),
            ("Test Song 1", "test_song_1"),
            ("Test Song 2", "test_song_2"),
            ("Test Song 3", "test_song_3"),
            ("Test Song 4", "test_song_4")
        ]
    ]

    func numberOfSections(in tableView: UITableView) -> Int {
        return songsAndAudioFiles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsAndAudioFiles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = songsAndAudioFiles[indexPath.section][indexPath.row].title
        contentConfiguration.image = UIImage(named: "music")
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTrackIndex = (section: indexPath.section, row: indexPath.row)
        let audioFileName = songsAndAudioFiles[indexPath.section][indexPath.row].fileName
        playAudio(fileName: audioFileName)
        tableView.deselectRow(at: indexPath, animated: true)
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
        // Connect toolbar buttons to actions
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
        
        // Add buttons to toolbar
        let flexibleSpace = UIBarButtonItem.flexibleSpace()
        toolbarItems = [rewindButton, flexibleSpace, playButton, flexibleSpace, stopButton, flexibleSpace, fastForwardButton]
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
        let nextRow = (currentTrackIndex.row + 1) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, nextRow)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][nextRow].fileName
        playAudio(fileName: audioFileName)
    }

    @objc private func previousTrack() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousRow = (currentTrackIndex.row - 1 + songsAndAudioFiles[currentTrackIndex.section].count) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, previousRow)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][previousRow].fileName
        playAudio(fileName: audioFileName)
    }

}

extension ViewControllerMusic : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText:String){
        if searchText.isEmpty{
            songsAndAudioFiles = defaultSongsAndAudioFiles
        }
        else{
            songsAndAudioFiles[0] = defaultSongsAndAudioFiles[0].filter{$0.0.hasPrefix(searchText)}
        }
        tableView.reloadData()
    }
}
