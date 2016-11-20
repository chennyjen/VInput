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
    }
    
    func initialize() {
        let textAfterMarker: String? = keyboardController.textDocumentProxy.documentContextAfterInput
        var shiftInputCount: Int = 1
        if textAfterMarker != nil {
            shiftInputCount = textAfterMarker!.characters.count
        }
        keyboardController.textDocumentProxy.adjustTextPosition(byCharacterOffset: shiftInputCount)
       
        let textBeforeMarker: String? = keyboardController.textDocumentProxy.documentContextBeforeInput
        if textBeforeMarker != nil && textBeforeMarker!.characters.last != " " {
            currentWord = loadFromProxy()
        }
    }
    
    func getModeName() -> String {
        return MODE_NAME
    }
    
    func onSwipeLeft() {
        values.shiftLeft()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func onSwipeRight() {
        values.shiftRight()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func onSwipeUp() {
        // TO DO
        let text = "Inserting " + values.getCurrentValue()
        SpeechUtil.speak(textToSpeak: text)
        currentWord.append(values.getCurrentValue())
        keyboardController.textDocumentProxy.insertText(values.getCurrentValue())
        values.isSearchingThenReset()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func swipeDown() {
        //TO-DO: Change this to be handled outside
        if !values.isSearchingThenReset() {
            if keyboardController.textDocumentProxy.documentContextBeforeInput == nil {
                SpeechUtil.speak(textToSpeak: "No characters to delete")
                return
            }
            SpeechUtil.speak(textToSpeak: "Deleting previous character")
            keyboardController.textDocumentProxy
                .deleteBackward()
            if !currentWord.isEmpty {
                currentWord = currentWord.substring(to: currentWord.index(before: currentWord.endIndex))
            }
            else if keyboardController.textDocumentProxy.documentContextBeforeInput?.characters.last != " " {
                currentWord = loadFromProxy()
                
            }
        }
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func doubleTap() {
        let text = "Left or right of " + values.getCurrentValue()
        SpeechUtil.speak(textToSpeak: currentWord)
    }
    
    func onHold() {
        SpeechUtil.speak(textToSpeak: "Inserting space")
        keyboardController.textDocumentProxy.insertText(" ")
        currentWord = ""
        values.isSearchingThenReset()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    private func loadFromProxy() -> String {
        let textInDocumentProxy : [String] = keyboardController.textDocumentProxy.documentContextBeforeInput!.components(separatedBy: " ").filter{$0.isEmpty == false}
        return textInDocumentProxy.isEmpty ? "" : textInDocumentProxy.last!
    
    }
}
