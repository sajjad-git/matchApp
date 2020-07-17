//
//  SoundManager.swift
//  matchApp
//
//  Created by Sajad on 2020-07-17.
//  Copyright © 2020 camelKase. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    var audioPlayer: AVAudioPlayer?
    
    enum SoundEffect {
        case flip
        case match
        case noMatch
        case shuffle
    }
    
    func playSound(effect: SoundEffect) {
        var soundFileName: String = "";
        
        switch(effect) {
        case .flip:
            soundFileName = "cardflip";
        case .match:
            soundFileName = "dingcorrect"
        case .noMatch:
            soundFileName = "dingwrong"
        case .shuffle:
            soundFileName = "shuffle";
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFileName, ofType: ".wav")
        
        // Check that it's not nill
        guard bundlePath != nil else {
            // couln't find the resource, exit
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            // create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch {
            print("Couldn't create an audio player")
            return
        }
    }
}
