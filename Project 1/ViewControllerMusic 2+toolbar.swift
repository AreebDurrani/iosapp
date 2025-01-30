//
//  ViewControllerMusic 2+toolbar.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/29/25.
//

import UIKit
import AVFoundation

extension ViewControllerMusic2 {
    
    // MARK: - Tool Bar Controls
    
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
    
    // MARK: - Playback Controls
    
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
    
    func nextSong() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let nextItem = (currentTrackIndex.item + 1) % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, nextItem)
        
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][nextItem].fileName
        let previewURL = fetchedTracks[nextItem].previewURL
        
        pauseButton.isHidden = false
        playButton.isHidden = true
        playAudio(withURL: previewURL)
    }
    
    func previousSong() {
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousItem = (currentTrackIndex.item - 1 + songsAndAudioFiles[currentTrackIndex.section].count)
                            % songsAndAudioFiles[currentTrackIndex.section].count
        self.currentTrackIndex = (currentTrackIndex.section, previousItem)
        
        let audioFileName = songsAndAudioFiles[currentTrackIndex.section][previousItem].fileName
        let previewURL = fetchedTracks[previousItem].previewURL
        
        pauseButton.isHidden = false
        playButton.isHidden = true
        playAudio(withURL: previewURL)
    }
    
    func setUpToolBarView() {
        toolBarView.layer.cornerRadius = 10
        toolBarView.layer.masksToBounds = true
    }
    
    // MARK: - Looping
    
    /// Toggles the looping state
    func loopButtonPressed() {
        looping.toggle()
    }
    
    /// Called when the current AVPlayerItem finishes playing
    @objc func didFinishPlaying(_ notification: Notification) {
        guard
            let currentItem = notification.object as? AVPlayerItem,
            let playerItem = player?.currentItem,
            currentItem == playerItem
        else {
            return
        }
        
        if looping {
            // Loop the current track
            player?.seek(to: .zero)
            player?.play()
        } else {
            // If not looping, we can stop or go to nextSong(), etc.
            stopSong()
            // Or for auto-next:
            // nextSong()
        }
    }
    
    /// Enables an observer to detect when a track finishes
    private func enableLoopingObserver(for playerItem: AVPlayerItem) {
        // Remove any existing observer to avoid duplicates
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
        
        // Add observer for "end of track" notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didFinishPlaying(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    // MARK: - Audio Playback
    
    func playAudio(withURL urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        
        // Create AVPlayerItem and AVPlayer
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Set up loop observation
        enableLoopingObserver(for: playerItem)
        
        // Start playback
        player?.play()
    }
    
    func stopSong() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        disableToolBar()
        
        // Optionally remove observer if we're done with this player
        if let currentItem = player?.currentItem {
            NotificationCenter.default.removeObserver(
                self,
                name: .AVPlayerItemDidPlayToEndTime,
                object: currentItem
            )
        }
    }
    
} // end of extension

