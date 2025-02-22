import UIKit
import AVFoundation

class CollectionViewControllerMusic: UICollectionViewController {
    
    var audioPlayer: AVAudioPlayer?
    var currentTrackIndex: (section: Int, item: Int)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbarActions()
        configureCollectionViewLayout()
    }

    let songsAndAudioFiles: [[(title: String, fileName: String)]] = [
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
        layout.itemSize = CGSize(width: 200, height: 50)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return songsAndAudioFiles.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songsAndAudioFiles[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicCell", for: indexPath)
        var contentConfiguration = UIListContentConfiguration.cell()
        contentConfiguration.text = songsAndAudioFiles[indexPath.section][indexPath.item].title
        contentConfiguration.image = UIImage(named: "music")
        cell.contentConfiguration = contentConfiguration
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}
