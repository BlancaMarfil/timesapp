//
//  SoundManager.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 30/12/21.
//

import Foundation
import AVKit

class SoundManager {
    
    static let instance = SoundManager() // Singleton
        
    var player: AVAudioPlayer?
    
    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "soft-alarm-ringtone", withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        player?.stop()
    }
}
