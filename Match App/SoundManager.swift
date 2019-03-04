//
//  SoundManager.swift
//  Match App
//
//  Created by Benjamin Howlett on 2019-03-04.
//  Copyright © 2019 Benjamin Howlett. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static  var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case noMatch
    }
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFilename = ""
        
        
        // Determine the sound effect we want to play and set the appropriate filename
        switch effect {
        
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .noMatch:
            soundFilename = "dingwrong"
    
        }
        
        // Get the path to the sound file in the bundle
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename)")
            return
        }
        
        // Create a URL object from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        // Create audio player object
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
        }
        catch {
            // Couldn't create audio player object, log the error
            print("Couldn't create the audio player object for the sound file \(soundFilename)")
        }
    }
    
}
