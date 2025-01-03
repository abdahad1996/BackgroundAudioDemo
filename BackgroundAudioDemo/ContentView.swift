//
//  ContentView.swift
//  BackgroundAudioDemo
//
//  Created by macbook abdul on 02/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()

    var body: some View {
        VStack {
            Text("Background Audio Player")
                .font(.headline)
                .padding()

            Button(action: {
                if audioManager.isPlaying {
                    audioManager.pauseAudio()
                } else {
                    audioManager.playAudio()
                }
            }) {
                Text(audioManager.isPlaying ? "Pause" : "Play")
                    .padding()
                    .background(audioManager.isPlaying ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            audioManager.configureAudioSession()
        }
    }
}
