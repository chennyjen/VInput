//
//  TrainingMode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class TrainingMode : InputMode {
    
    var defaultTrainingWords: [String] = ["Michael"]
    var providedTrainingWords: [String]? = nil
    var stateIndex: Int = 0
    var startingIndex: Int = 0
    var key: Key? = nil
    var shouldSwapBack: Bool = false
    var trainingLevel: TRAINING_LEVELS = .all
    
    init(values: Values, keyboardController: KeyboardViewController, key: Key? = nil) {
        if key != nil {
            self.key = key
            self.stateIndex = key!.getIndex()
            self.providedTrainingWords = key!.getStrings()
            if key!.getMode() == .tutorial { //place holder to simplify for now
                self.shouldSwapBack = true
            }
        }
        super.init(values: values, keyboardController: keyboardController)
    }
    
    override func getModeName() -> String {
        return "Training Mode" //Holder for now
    }
    
    override func initialize() {
//        SpeechUtil.speak(textToSpeak: "Entered Training Mode")
//        SpeechUtil.blockIfSpeeking()
        var text = ""
        
        if providedTrainingWords != nil {
            if stateIndex == 1 {
                text = "Try finding the letter " + providedTrainingWords![0] + ". Hold on the screen with one finger when you find it"
            }
            else if (stateIndex == 3) {
                text = "Try to spell out " + providedTrainingWords![0]
            }
            else {
                text = "The first word to spell is " + providedTrainingWords![0]
            }
        }
        else {
            text = "The first word to spell is " + defaultTrainingWords[0]
        }
        SpeechUtil.speak(textToSpeak: text)
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    override func onSwipeUp() {
        SpeechUtil.speak(textToSpeak: "Inserting " + values.getCurrentValue())
        currentWord.append(values.getCurrentValue())
        values.isSearchingThenReset()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    override func swipeDown() {
        if !values.isSearchingThenReset() {
            if trainingLevel.rawValue >= TRAINING_LEVELS.delete.rawValue && !currentWord.isEmpty {
                SpeechUtil.speak(textToSpeak: "Deleting previous character")
                currentWord = currentWord.substring(to: currentWord.index(before: currentWord.endIndex))
            }
            else {
                SpeechUtil.speak(textToSpeak: "No characters in this word to delete")
            }
        }
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    //Indicates end of word
    override func onHold() {
        currentWord = ""
        startingIndex += 1
        values.isSearchingThenReset()
        
        if trainingLevel == .space && startingIndex < key!.getStrings().count {
            SpeechUtil.speak(textToSpeak: "Space inserted")
        }
        
        if shouldSwapBack && startingIndex >= key!.getStrings().count {
            ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(index: stateIndex + 1, callingMode: .training), mode: key!.getMode())
            return
        }
        
        var text = "The next word to spell is "
        text += providedTrainingWords != nil ? providedTrainingWords![startingIndex] : defaultTrainingWords[startingIndex]
        SpeechUtil.speak(textToSpeak: text)
        
    }
    
    enum TRAINING_LEVELS: Int {
        case leftRightUp = 0, fullword, space, delete, promptLetter, promptWord, all
    }
}
