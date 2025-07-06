//
//  AudioManager.swift
//  Wayfarer
//
//  Created by Franco Miguel Guevarra on 1/26/25.
//

import Foundation
import AVFoundation

@Observable
class AudioManager {

    @MainActor static let shared = AudioManager()

    private var players: [String: AVAudioPlayer] = [
        "music": AVAudioPlayer(),
        "dialog": AVAudioPlayer(),
        "controls": AVAudioPlayer(),
        "tv": AVAudioPlayer()
    ]
    
    init() {
        setupControlsPlayer()
    }
    
    private func loadAudio(fileName: String, fileExtension: String, for key: String) -> AVAudioPlayer? {
        guard let soundURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Sound file \(fileName).\(fileExtension) not found")
            return nil
        }
        
        if !players.keys.contains(key) {
            return nil
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            players.updateValue(player, forKey: key)
            return player
        } catch {
            return nil
        }
    }
    
    func startMusic() {
        guard let musicPlayer = loadAudio(fileName: "Soundtrack", fileExtension: "mp3", for: "music") else { return }
        
        if musicPlayer.isPlaying || musicPlayer.currentTime > 0 {
            return
        }
        
        musicPlayer.volume = 0.05
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    private func setupControlsPlayer() {
        guard let controlsPlayer = loadAudio(fileName: "Key_Press", fileExtension: "wav", for: "controls") else { return }
        controlsPlayer.volume = 0.08
        controlsPlayer.prepareToPlay()
    }
    
    func playKeyPress() {
        players["controls"]?.currentTime = 0
        players["controls"]?.play()
    }
    
    func playDialogEffect(_ sound: DialogFX) {
        guard let dialogPlayer = loadAudio(fileName: sound.rawValue, fileExtension: "wav", for: "dialog") else { return }
        
        dialogPlayer.volume = sound.volume
        dialogPlayer.enableRate = true
        dialogPlayer.rate = sound.rate
        dialogPlayer.currentTime = 0
        dialogPlayer.play()
    }
    
    func playTVEffect(switchChannel: Bool = false) {
        guard let tvPlayer = loadAudio(
            fileName: switchChannel ? "TV_Switch" : "TV_On",
            fileExtension: "wav",
            for: "tv"
        ) else { return }
        tvPlayer.volume = switchChannel ? 0.03 : 0.05
        tvPlayer.play()
    }
    
    func playDialogBeep(count: Int) {
        guard let dialogPlayer = loadAudio(fileName: "Dialog_Beep", fileExtension: "wav", for: "dialog") else { return }
        dialogPlayer.volume = 0.04
        dialogPlayer.enableRate = true
        dialogPlayer.rate = 1.2
        dialogPlayer.numberOfLoops = Int(count / 5)
        dialogPlayer.play()
    }
}

extension AudioManager {
    enum DialogFX: String {
        case dialogBeep = "Dialog_Beep"
        case dialogNext = "Dialog_Next"
        case dialogLoad = "Dialog_Load"
        case dialogWrong = "Dialog_Wrong"
        case dialogCorrect = "Dialog_Correct"
        
        var rate: Float {
            switch self {
            case .dialogNext: return 1.3
            case .dialogLoad: return 0.9
            default: return 1.0
            }
        }
        
        var volume: Float {
            switch self {
            case .dialogLoad:
                0.04
            case .dialogWrong:
                0.09
            default:
                0.08
            }
        }
    }

}
