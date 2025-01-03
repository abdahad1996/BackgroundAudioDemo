//
//  AudioManager.swift
//  BackgroundAudioDemo
//
//  Created by macbook abdul on 02/01/2025.
//


import SwiftUI
import AVFoundation
import MediaPlayer

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false

    func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true)
            setupNowPlayingInfoCenter()
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    func playAudio() {
        guard let url = Bundle.main.url(forResource: "sample_audio", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }

        do {
            if audioPlayer == nil {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
            }
            audioPlayer?.play()
            isPlaying = true
            updateNowPlayingInfo(isPlaying: true)
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }

    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
        updateNowPlayingInfo(isPlaying: false)
    }

    private func setupNowPlayingInfoCenter() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = "Sample Audio"

        if let artworkImage = UIImage(named: "artwork") {
            let artwork = MPMediaItemArtwork(boundsSize: artworkImage.size) { _ in artworkImage }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.playAudio()
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pauseAudio()
            return .success
        }
    

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pauseAudio()
            return .success
        }
    }

    private func updateNowPlayingInfo(isPlaying: Bool) {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
