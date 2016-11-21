//
//  TutorialMode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//
import Foundation

class TutorialMode : Mode {

    let DUMMY: String = "Tutorial Mode"
    //override let MODE_NAME = "TutorialMode"
    var tutorialIndex: Int!
    var values: Values
    var keyboardController: KeyboardViewController
    
    //Mike and Jenny Comments:
    //1) single letter (L/R, Up)
    //2) full word
    //3) space
    //4) delete
    //5) Pan down to exit
    // 6) upper case (maybe move before 5)
    // ADVANCED
    // 7) Two finger tap -> read back letter
    // 8) Two finger hold -> read back current word
    
    let tut : [String] = ["Welcome to VInput, a text input application for the visually impaired. Swipe left and right to navigate between sections of this tutorial or swipe down to exit.",
                          "Section 1: Getting started. To start using VInput imagine the alphabet as a string of letters next to each other. For example, the letter A is left of B and the letter D is right of C. To spell a word, you will search along the alphabet to find each letter. VInput will prompt you with a letter. Swipe left or right of the prompted letter toward the letter you are looking for. Swipe up to select the current letter. Swipe up to test these gestures. Swipe right to learn a new gesture",
                          "Section 2: Spelling full words. VInput will automatically restart the search for you after you have inserted a letter by swiping up. Swipe up to test this gesture. Swipe right to learn a new gesture",
                          "Section 3: Inserting a space. To insert a space,hold down with one finger on the screen until VInput says a space has been inserted. Swipe up to test this gesture. Swipe right to learn a new gesture",
                          "Section 4: Restarting the search and deleting a letter. If at any time you would like to stop your current search and restart, swipe down. If you would like to delete the last letter you entered, swipe down again. Swipe up to test this gesture. Swipe right to learn a new gesture",
                          "Section 5: Capitalization. To capitalize a letter, double tap the screen with one finger just before you swipe up to select it. Swipe up to test this gesture. Swipe right to learn a new gesture",
                          "Section 6: Advanced gestures. At any time, tap the screen with two fingers to read back the letter you are on in the search. Hold the screen with two fingers to read back the current word you are typing. Swipe up to test this gesture. Swipe right to learn a new gesture",
        "You've reached the end of this tutorial. To continue training, swipe up now. To exit this tutorial, swipe down."]
    
    init(values: Values, keyboardController: KeyboardViewController, tutorialIndexState: Int = 0) {
        self.values = values
        self.keyboardController = keyboardController
        self.tutorialIndex = tutorialIndexState
    }
    
    func initialize() {
        KeyboardViewController.letterLabel.text = ""
        if tutorialIndex == 0 {
            SpeechUtil.speak(textToSpeak: "You've entered tutorial mode.", postDelay: TimeInterval(4))
            SpeechUtil.speak(textToSpeak: tut[tutorialIndex], postDelay: TimeInterval(4))
            tutorialIndex = tutorialIndex + 1
        }
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
    }
    
    
    func getModeName() -> String {
        return "Tutorial_Mode"
    }
    
    func onSwipeLeft() {
        SpeechUtil.stopSpeech()
        if tutorialIndex > 0 {
            tutorialIndex = tutorialIndex - 1
        }
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
    }
    
    func onSwipeRight() {
        SpeechUtil.stopSpeech()
        if tutorialIndex < tut.count{
            tutorialIndex = tutorialIndex + 1
        }
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
    }
    
    func onSwipeUp() {
        SpeechUtil.stopSpeech()
        launchTraining()
    }
    
    func swipeDown() {
        SpeechUtil.stopSpeech()
        SpeechUtil.speak(textToSpeak: "Exiting tutorial mode")
        ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(index: tutorialIndex, callingMode: .tutorial), mode: .input)
    }
    
    func doubleTap() {
        SpeechUtil.stopSpeech()
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
    }
    
    func onHold() {
        return
    }
    
    //Holder:
    private func launchTraining() {
        var trainingStrings: [String] = []
        switch tutorialIndex {
            case 1:
                trainingStrings = ["b"] //single letter
            case 2:
                trainingStrings = ["flower"] //full word
            case 3:
                trainingStrings = ["I love spaces"] //training for spaces
            // train for delete; not sure what to pass here
            case 4, 5:
                trainingStrings = ["India", "Michigan"] //capitalization
            case 6:
                trainingStrings = ["University","difficult", "computational"]
            default:
                return
        }
        ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(index: tutorialIndex, trainingStrings: trainingStrings, callingMode: .tutorial), mode: .training)
    }
}
