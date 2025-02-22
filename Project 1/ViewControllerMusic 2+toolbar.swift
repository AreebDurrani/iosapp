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
        loopButton.isHidden = true
    }
    
    func enableToolBar() {
        playButton.isHidden = true
        pauseButton.isHidden = false
        forwardButton.isHidden = false
        backwardButton.isHidden = false
        toolBarView.isHidden = false
        stopButton.isHidden = false
        loopButton.isHidden = false
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
        let nextItem = (currentTrackIndex.item + 1) % fetchedTracks.count // Updated to use fetchedTracks.count
        self.currentTrackIndex = (currentTrackIndex.section, nextItem)
        let previewURL = fetchedTracks[nextItem].previewURL // Correctly uses fetchedTracks
        pauseButton.isHidden = false
        playButton.isHidden = true
        playAudio(withURL: previewURL)
    }

    func previousSong(){
        guard let currentTrackIndex = currentTrackIndex else { return }
        let previousItem = (currentTrackIndex.item - 1 + fetchedTracks.count) % fetchedTracks.count // Updated
        self.currentTrackIndex = (currentTrackIndex.section, previousItem)
        let previewURL = fetchedTracks[previousItem].previewURL // Correctly uses fetchedTracks
        pauseButton.isHidden = false
        playButton.isHidden = true
        playAudio(withURL: previewURL)
    }
    
    
    func switchLoop(_ sender: UIButton){
        if loopSong == true{
            sender.tintColor = UIColor.gray
            loopSong = false
        }
        else{
            sender.tintColor = UIColor(red: 233/255, green: 215/255, blue: 114/255, alpha: 1)
            loopSong = true
        }
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
        
        // Cleanup previous observers
        removePeriodicTimeObserver()
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        // Create new player
        player = AVPlayer(url: url)
        
        // Setup observers
        addPeriodicTimeObserver()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerDidFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
        
        // Reset progress
        songProgressView.value = 0.0
        player?.play()
    }
    
    func stopSong() {
        player?.pause()
        player?.seek(to: CMTime.zero)
        songProgressView.value = 0.0
        disableToolBar()
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                  let player = self.player,
                  !self.isSliding else { return }
            
            let currentTime = time.seconds
            guard let duration = player.currentItem?.duration.seconds,
                  duration > 0 else { return }
            
            self.songProgressView.value = Float(currentTime / duration)
        }
    }

    private func removePeriodicTimeObserver() {
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }

    @objc func playerDidFinishPlaying(note: NSNotification) {
        songProgressView.value = 1.0
        if loopSong{
            player?.seek(to: CMTime.zero)
            songProgressView.value = 0.0
            player?.play()
        }
        else{
            nextSong()
        }
    }
    
}
