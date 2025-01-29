//
//  ViewControllerMusic 2+toolbar.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/29/25.
//

import UIKit
import AVFoundation

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
        playButton.isHidden = true
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
        pauseButton.isHidden = false
        playButton.isHidden = true
        playAudio(withURL: previewURL)
    }
    
    func previousSong(){
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousItem = (currentTrackIndex.item - 1 + songsAndAudioFiles[currentTrackIndex.section].count) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, previousItem)
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][previousItem].fileName
        let previewURL = fetchedTracks[previousItem].previewURL
        pauseButton.isHidden = false
        playButton.isHidden = true
        playAudio(withURL: previewURL)
    }
    
    func setUpToolBarView(){
        toolBarView.layer.cornerRadius = 10
        toolBarView.layer.masksToBounds = true
    }
    
    func playAudio(withURL urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Create the player with the URL and start playback
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func stopSong() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        disableToolBar()
    }
    

    
}
