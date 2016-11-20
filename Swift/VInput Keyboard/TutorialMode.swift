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
    //let speechSynthesizer = AVSpeechSynthesizer()
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
                          "Section 1: Getting started. To start using VInput imagine the alphabet as a string of letters next to each other. For example, the letter A is left of B and the letter D is right of C. To spell a word, you will search along the alphabet to find each letter. VInput will prompt you with a letter. Swipe left or right of the prompted letter toward the letter you are looking for. Swipe up to select the current letter. Try searching for a few letters now.",
                          "Section 2: Spelling full words. VInput will automatically restart the search for you after you have inserted a letter by swiping up. Try spelling out a few full words now.",
                          "Section 3: Inserting a space. To insert a space,hold down with one finger on the screen until VInput says a space has been inserted. Try this now by spelling a sentence.",
                          "Section 4: Restarting the search and deleting a letter. If at any time you would like to stop your current search and restart, swipe down. If you would like to delete the last letter you entered, swipe down again.",
                          "Section 5: Capitalization. To capitalize a letter, double tap the screen with one finger just before you swipe up to select it. Try this out now by spelling these proper nouns.",
                          "Section 6: Advanced gestures. At any time, tap the screen with two fingers to read back the letter you are on in the search. Hold the screen with two fingers to read back the current word you are typing. Try these gestures while spelling these words now."
                          "You've reached the end of this tutorial. To launch an interactive training mode, swipe up now. To exit this tutorial, swipe down."]
    
    init(values: Values, keyboardController: KeyboardViewController, tutorialIndexState: Int = 0) {
        self.values = values
        self.keyboardController = keyboardController
        self.tutorialIndex = tutorialIndexState
        SpeechUtil.speak(textToSpeak: "You've entered tutorial mode.", postDelay: TimeInterval(4))
        SpeechUtil.speak(textToSpeak: tut[self.tutorialIndex])
        //launchTrainingStage()
    }
    
    //    override init(values: Values) {
    //        //self.values = values
    //        //        let welcome = "You've entered tutorial mode. Welcome to VInput, a text input application for the visually impaired. Swipe left and right to navigate between sections of this tutorial."
    //        //        let getting_started = "Getting started. To start using VInput imagine the alphabet as a string of letters next to each other. For example, the letter A is left of B and the letter D is right of C. To spell a word, you will search along the alphabet to find each letter."
    //        //        let navigation = "Navigation. VInput will prompt you with a letter. Swipe left or right of the prompted letter toward the letter you are looking for. For example, if you are looking for letter Z and VInput prompts you with M, swipe right."
    //        //        let letter_selection = "Letter selection. If at any time VInput prompts you with the letter you are searching for, swipe up to select the letter."
    //        //        let restart_delete = "Restarting the search. If at any time you would like to stop your current search and restart, swipe down. If you would like to delete the last letter you entered, swipe down again."
    //        //        let enter_space = "Entering a space. To enter a space, hold down with one finger on the screen until VInput says a space has been inserted"
    //        //        let read_back = "Reading back current letter. If at any time you would like to hear where you are in the search again, double tap the screen." //double tap
    //        //        let launch_training = "You've reached the end of this tutorial. To launch an interactive training mode, swipe up now. To exit this tutorial, swipe down."
    //
    //
    //        SpeechUtil.speak(textToSpeak: tut[index])
    //        super.init(values: tut_values)
    //    }
    
    func getModeName() -> String {
        return "Tutorial_Mode"
    }
    
    func onSwipeLeft() {
        SpeechUtil.stopSpeech()
        if tutorialIndex > 0 {
            tutorialIndex = tutorialIndex - 1
        }
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
        //TODO: launch training mode only after done speaking
        //launchTrainingStage()
    }
    
    func onSwipeRight() {
        SpeechUtil.stopSpeech()
        if tutorialIndex < tut.count{
            tutorialIndex = tutorialIndex + 1
        }
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
    }
    
    func onSwipeUp() {
        // TO DO: Enter Training mode
    }
    
    func swipeDown() {
        //TODO: Enter Input Mode
        ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(index: tutorialIndex), mode: "Input_Mode")
    }
    
    func doubleTap() {
        SpeechUtil.stopSpeech()
        SpeechUtil.speak(textToSpeak: tut[tutorialIndex])
    }
    
    func onHold() {
    }
    
    //Holder:
    private func launchTrainingStage() {
        var trainingStrings: [String] = []
        switch tutorialIndex {
        case 1:
            trainingStrings = ['b','o','n'] //single letter
        case 2:
            trainingStrings = ['cat','walk','flower'] //full word
        case 3:
            trainingStrings = ['I love spaces'] //training for spaces
        //case 4:
            // train for delete; not sure what to pass here
        case 5:
            trainingStrings = ['India', 'Michigan'] //capitalization
        case 6:
            trainingStrings = ['University','difficult', 'computational']
        default:
            return
        }
        ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(index: tutorialIndex, trainingStrings: trainingStrings), mode: "Input_Mode")
    }
}
