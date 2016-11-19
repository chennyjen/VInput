//
//  TutorialMode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//
import Foundation

class TutorialMode : InputMode {
    
    var tut_values: Values!
    var tut_keyboardController: KeyboardViewController!

    //override let MODE_NAME = "TutorialMode"
    //let speechSynthesizer = AVSpeechSynthesizer()
    var index = 0
    let tut : [String] = ["You've entered tutorial mode. Welcome to VInput, a text input application for the visually impaired. Swipe left and right to navigate between sections of this tutorial. At any point, swipe up to enter an interactive training mode, or swipe down to exit.","Section 1: Getting started. To start using VInput imagine the alphabet as a string of letters next to each other. For example, the letter A is left of B and the letter D is right of C. To spell a word, you will search along the alphabet to find each letter.","Section 2: Navigation. VInput will prompt you with a letter. Swipe left or right of the prompted letter toward the letter you are looking for. For example, if you are looking for letter Z and VInput prompts you with M, swipe right.","Section 3: Letter selection. If at any time VInput prompts you with the letter you are searching for, swipe up to select the letter.","Restarting the search. If at any time you would like to stop your current search and restart, swipe down. If you would like to delete the last letter you entered, swipe down again.","Section 4: Entering a space. To enter a space, hold down with one finger on the screen until VInput says a space has been inserted.","Reading back current letter. If at any time you would like to hear where you are in the search again, double tap the screen." ,"You've reached the end of this tutorial. To launch an interactive training mode, swipe up now. To exit this tutorial, swipe down."]
    
    init() {
        SpeechUtil.speak(textToSpeak: tut[index])
        super.init(values: tut_values, keyboardController: tut_keyboardController)
//        self.values = tut_values
//        self.keyboardController = tut_keyboardController
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
    
    override func getModeName() -> String {
        return "TutorialMode"
    }
    
    override func onSwipeLeft() {
        SpeechUtil.stopSpeech()
        if index > 0{
            index -= 1
            SpeechUtil.speak(textToSpeak: tut[index])
        }
    }
    
    override func onSwipeRight() {
        SpeechUtil.stopSpeech()
        if index < tut.count{
            index += 1
            SpeechUtil.speak(textToSpeak: tut[index])
        }
    }
    
    override func onSwipeUp() {
        // TO DO: Enter Training mode
    }
    
    override func swipeDown() {
        //TODO: Enter Input Mode
    }
    
    override func doubleTap() {
        SpeechUtil.stopSpeech()
        SpeechUtil.speak(textToSpeak: tut[index])
    }
    
    override func onHold() {
    }
}
