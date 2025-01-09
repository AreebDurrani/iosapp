import UIKit
import AVFoundation

class TableViewControllerMusic: UITableViewController {
    
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Nested Array for Songs and Audio File Names
    let songsAndAudioFiles: [[(title: String, fileName: String)]] = [
        [
            ("Moonlight Sonata", "moonlight_sonata"), ("testSong1", "moonlight_sonata"), ("testSong2", "moonlight_sonata"), ("testsong3", "moonlight_sonata"), ("testsong4", "moonlight_sonata")
        ]
    ]

    // Create sections based on the length of the nested array
    override func numberOfSections(in tableView: UITableView) -> Int {
        return songsAndAudioFiles.count
    }
    
    // Create rows based on the length of the section subarray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsAndAudioFiles[section].count
    }
    
    // Fill cell text based on the nested array
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = songsAndAudioFiles[indexPath.section][indexPath.row].title
        contentConfiguration.image = UIImage(named: "music")
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    // Handle cell selection to play the corresponding audio file
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioFileName = songsAndAudioFiles[indexPath.section][indexPath.row].fileName
        playAudio(fileName: audioFileName)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Function to play audio using NSDataAsset
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
}

