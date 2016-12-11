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
import CoreData

class InputMode : Mode {
    
//    var values: Values!
    var keyboardController: KeyboardViewController!
    let MODE_NAME = "InputMode"
    var currentWord: String = ""
    var swapBack: Bool = false
    
    init(keyboardController: KeyboardViewController) {
//        self.values = values
        self.keyboardController = keyboardController
        self.swapBack = false
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
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func getModeName() -> String {
        return MODE_NAME
    }
    
    func onSwipeLeft() {
        if swapBack && keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
            swapBack = false
        }
        keyboardController.currentValues.shiftLeft()
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func onSwipeRight() {
        if swapBack && keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
            swapBack = false
        }
        keyboardController.currentValues.shiftRight()
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func onSwipeUp() {
        // TO DO
        var text = "Inserting " + keyboardController.currentValues.getCurrentValue()
        if keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase{
            text = "Inserting upper case " + keyboardController.currentValues.getCurrentValue()
        }
        SpeechUtil.speak(textToSpeak: text)
        currentWord.append(keyboardController.currentValues.getCurrentValue())
        keyboardController.textDocumentProxy.insertText(keyboardController.currentValues.getCurrentValue())
        if swapBack && keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase{
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
            swapBack = false
        }
        keyboardController.currentValues.resetIndexes()
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
        
        
        // search for results
        let partialTypedWord = loadFromProxy()
        // Threshold for when to start "predicting"
        if partialTypedWord.characters.count < 3 {
            return
        }
        let context = self.keyboardController.persistentContainer!.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.predicate = NSPredicate(format: "word beginswith[c] %@", partialTypedWord)
        request.entity = NSEntityDescription.entity(forEntityName: "TypedWord", in: context)
        request.sortDescriptors = [NSSortDescriptor(key: "frequency", ascending: false)]
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                // PRINT ALL WORDS
                for result in results {
                    print((result as! TypedWord).word)
                    print((result as! TypedWord).frequency)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func swipeDown() {
        //TO-DO: Change this to be handled outside
        if !keyboardController.currentValues.isSearchingResetAndAnounce() {
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
                //reload word here and decrement from count
            }
        }
        if swapBack && keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
            swapBack = false
        }
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func onHold() {
        //TODO: This needs to be refactored throughout
        if keyboardController.currentValues.getValueType() == .lowercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.uppercase)
            VisualUtil.updateView(letter: keyboardController.currentValues.getCurrentValue())
            swapBack = true
            SpeechUtil.speak(textToSpeak: "Current letter upper cased" )
        }
        else if keyboardController.currentValues.getValueType() == .uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
            VisualUtil.updateView(letter: keyboardController.currentValues.getCurrentValue())
            swapBack = false
            SpeechUtil.speak(textToSpeak: "Current letter lower cased")
        }
    }
    
    func onLongHold() {
        ModeUtil.swapMode(keyboardController: keyboardController, stateKey: Key(index: 0, callingMode: .input), mode: .tutorial)
    }
    
    func doubleTap() {
        
        SpeechUtil.speak(textToSpeak: "Inserting space")
        keyboardController.textDocumentProxy.insertText(" ")
        currentWord = ""
        
        if keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase{
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
        }
        
        // Save word to Core Data
        let lastWordTyped = loadFromProxy()
        
        let context = self.keyboardController.persistentContainer!.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.predicate = NSPredicate(format: "word = %@", lastWordTyped)
        request.entity = NSEntityDescription.entity(forEntityName: "TypedWord", in: context)
        
        do {
            let results = try context.fetch(request)
            let wordToInsertOrUpdate: TypedWord?
            if results.count == 0 {
                wordToInsertOrUpdate = NSEntityDescription.insertNewObject(forEntityName: "TypedWord", into: context) as! TypedWord
                wordToInsertOrUpdate!.word = lastWordTyped
                wordToInsertOrUpdate!.frequency = 0
            } else {
                wordToInsertOrUpdate = (results[0] as! TypedWord)
            }
            wordToInsertOrUpdate!.frequency += 1
            try context.save()
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        // PRINT ALL WORDS
        let request2 = NSFetchRequest<NSFetchRequestResult>()
        request2.entity = NSEntityDescription.entity(forEntityName: "TypedWord", in: context)
        
        do {
            let results = try context.fetch(request2)
            for result in results {
                print((result as! TypedWord).word)
                print((result as! TypedWord).frequency)
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }     
        //TO-DO: Figure out on-hold behavior if in the middle of the search
        keyboardController.currentValues.resetIndexes()
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    
    func onTwoTouchTap() {
        SpeechUtil.speak(textToSpeak: "Left or right of " + keyboardController.currentValues.getCurrentValue())
    }
    
    func onTwoTouchHold() {
        var text = ""
        if (currentWord != ""){
            text = "Current word: " + currentWord
        }
        else {
            text = "No letters in current word yet."
        }
        SpeechUtil.speak(textToSpeak: text)
    }
    

    func onTwoFingerSwipeRight() {
        
        let currentValueType: ValueUtil.VALUE_TYPE = keyboardController.currentValues.getValueType()
        let numValueTypes: Int = ValueUtil.VALUE_TYPE.numValueTypes(currentValueType)() + 1
        print("$$$$$$ " + String(numValueTypes))
        ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE(rawValue: ((currentValueType.rawValue + 1) % numValueTypes))!)
        
        //TODO: Clean and refactor this
        let valHolder: Int = keyboardController.currentValues.getValueType().rawValue
        var text: String = "Switching to "
        switch valHolder {
        case 0:
            text += "lower case alphabet"
        case 1:
            text += "upper case alphabet"
        case 2:
            text += "numbers 0 through 9"
        case 3:
            text += "emoticons"
        case 4:
            text += "punctuation"
        case 5:
            text += "your most common words"
        default:
            break
        }
        SpeechUtil.speak(textToSpeak: text)
        
        keyboardController.currentValues.resetIndexes()
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
        
    }
    
    private func loadFromProxy() -> String {
        let textInDocumentProxy : [String] = keyboardController.textDocumentProxy.documentContextBeforeInput!.components(separatedBy: " ").filter{$0.isEmpty == false}
        return textInDocumentProxy.isEmpty ? "" : textInDocumentProxy.last!
    }
}
