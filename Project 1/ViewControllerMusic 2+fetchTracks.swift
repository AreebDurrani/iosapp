//
//  ViewControllerMusic 2+fetchTracks.swift
//  Project 1
//
//  Created by Kenneth Yang on 1/29/25.
//

import Foundation

extension ViewControllerMusic2 {
    func fetchTracks(completion: @escaping () -> Void){
        fetchRockTracksWithPreview { tracks in
            for track in tracks {
                self.fetchedTracks.append(track)
                self.defaultSongData.append(track)
                //print("Track: \(track.title), Artist: \(track.artist), Preview URL: \(track.previewURL)")
            }
            completion()
        }
    }
}
