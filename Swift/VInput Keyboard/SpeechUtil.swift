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
    static var speechSynthesizer = AVSpeechSynthesizer()
    static var punctuationKeys: [String:String] = [
        "Left or right of ," : "Left or right of comma",
        "Left or right of ." : "Left or right of period",
        "Left or right of -" : "Left or right of hyphen",
        "Left or right of \"" : "Left or right of double quotation mark",
        "Left or right of _" : "Left or right of underscore",
        "Left or right of \'" : "Left or right of single quotation mark",
        "Left or right of )" : "Left or right of close paranthesis",
        "Left or right of (" : "Left or right of open paranthesis",
        "Left or right of ;" : "Left or right of semi-colon",
        "Left or right of =" : "Left or right of equal sign",
        "Left or right of :" : "Left or right of colon",
        "Left or right of /" : "Left or right of forward slash",
        "Left or right of *" : "Left or right of asteric",
        "Left or right of !" : "Left or right of exclamation point",
        "Left or right of ?" : "Left or right of question mark",
        "Left or right of $" : "Left or right of dollar sign",
        "Left or right of &" : "Left or right of ampersand",
        "Left or right of @" : "Left or right of at sign"
    ]
    
    static func speak(textToSpeak: String, pitchMultiplier: Float = 1.0,
                      postDelay: TimeInterval = TimeInterval(0),
                      preDelay: TimeInterval = TimeInterval(0),
                      speechRate: Float = 0.55) {
//        if textToSpeak.range(of: " a") != nil {
//            
//        }
        utterance = AVSpeechUtterance(string: textToSpeak)
        // TODO some of these values should be exposed as options in the Settings bundle
        utterance.pitchMultiplier = pitchMultiplier
        //utterance.postUtteranceDelay = postDelay
        utterance.preUtteranceDelay = preDelay
        utterance.rate = speechRate
        print(textToSpeak)
        if let newText = punctuationKeys[textToSpeak] {
            utterance = AVSpeechUtterance(string: newText)
        }
        speechSynthesizer.speak(utterance)
    }
    
    static func generatePrompt() {
        //TO-DO: Implement a speach generation here
    }
    
    static func stopSpeech() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            speechSynthesizer = AVSpeechSynthesizer()
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
