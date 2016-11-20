//
//  Utils.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation
import AVFoundation

class SpeechUtil {
    
    static var utterance: AVSpeechUtterance!
    static let speechSynthesizer = AVSpeechSynthesizer()
    
    static func speak(textToSpeak: String, pitchMultiplier: Float = 1.0, postDelay: TimeInterval = TimeInterval(0)) {
        utterance = AVSpeechUtterance(string: textToSpeak)
        // TODO some of these values should be exposed as options in the Settings bundle
        utterance.pitchMultiplier = pitchMultiplier
        //utterance.postUtteranceDelay = postDelay
        utterance.rate = 0.5
        speechSynthesizer.speak(utterance)
    }
    
    static func generatePrompt() {
        //TO-DO: Implement a speach generation here
    }
    
    static func stopSpeech() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
    }
    
    static func blockIfSpeeking() {
        while speechSynthesizer.isSpeaking {
            print("blocking")
        }
    }
    
    static func checkIfSpeaking() -> Bool {
        if speechSynthesizer.isSpeaking {
            return true
        }
        else {
            return false
        }
    }
}
