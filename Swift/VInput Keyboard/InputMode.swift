//
//  TutorialMode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class InputMode : Mode {
    
    var values: Values!
    var keyboardController: KeyboardViewController!
    let MODE_NAME = "InputMode"
    var currentWord: String = ""
    
    init(values: Values, keyboardController: KeyboardViewController) {
        self.values = values
        self.keyboardController = keyboardController
        self.currentWord = self.loadFromProxy()
//        keyboardController.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
//        SpeechUtil.speak(textToSpeak: self.loadFromProxy())
//        SpeechUtil.speak(textToSpeak: "Input mode")
        SpeechUtil.speak(textToSpeak: keyboardController.textDocumentProxy.documentContextBeforeInput!)
    }
    
    func getModeName() -> String {
        return MODE_NAME
    }
    
    func onSwipeLeft() {
        SpeechUtil.stopSpeech()
        values.shiftLeft()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func onSwipeRight() {
        SpeechUtil.stopSpeech()
        values.shiftRight()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func onSwipeUp() {
        // TO DO
        SpeechUtil.stopSpeech()
        let text = "Inserting " + values.getCurrentValue()
        SpeechUtil.speak(textToSpeak: text)
        currentWord.append(values.getCurrentValue())
        keyboardController.textDocumentProxy.insertText(values.getCurrentValue())
        values.isSearchingThenReset()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func swipeDown() {
        //TO-DO: Change this to be handled outside
        SpeechUtil.stopSpeech()
        if !values.isSearchingThenReset() {
            SpeechUtil.speak(textToSpeak: "Deleting previous character")
            keyboardController.textDocumentProxy.deleteBackward()
            currentWord = currentWord.substring(to: currentWord.index(before: currentWord.endIndex))
//            if currentWord.isEmpty {
//                currentWord = loadFromProxy()
//            }
        }
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func doubleTap() {
        SpeechUtil.stopSpeech()
        let text = "Left or right of " + values.getCurrentValue()
//        keyboardController.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
//        SpeechUtil.speak(textToSpeak: loadFromProxy())
        ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(), mode: "Tutorial_Mode")
    }
    
    func onHold() {
        SpeechUtil.stopSpeech()
        //Reset search here?
        keyboardController.textDocumentProxy.insertText(" ")
        currentWord = ""
        SpeechUtil.speak(textToSpeak: "Inserting space")
    }
    
    private func loadFromProxy() -> String {
        let textInDocumentProxy : [String] = keyboardController.textDocumentProxy.documentContextBeforeInput!.components(separatedBy: " ")
        return textInDocumentProxy.last!
    }
}
