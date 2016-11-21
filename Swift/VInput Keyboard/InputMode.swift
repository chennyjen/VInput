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
    
    init(keyboardController: KeyboardViewController) {
//        self.values = values
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
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func getModeName() -> String {
        return MODE_NAME
    }
    
    func onSwipeLeft() {
        if keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
        }
        keyboardController.currentValues.shiftLeft()
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func onSwipeRight() {
        if keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
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
        if keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase{
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
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
                
            }
        }
        if keyboardController.currentValues.getValueType() == ValueUtil.VALUE_TYPE.uppercase{
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
        }
        VisualUtil.updateViewAndAnnounce(letter: keyboardController.currentValues.getCurrentValue())
    }
    
    func onHold() {
        if keyboardController.currentValues.getValueType() == .lowercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.uppercase)
            VisualUtil.updateView(letter: keyboardController.currentValues.getCurrentValue())
            SpeechUtil.speak(textToSpeak: "Current letter upper cased" )
        }
        else if keyboardController.currentValues.getValueType() == .uppercase {
            ValueUtil.swapMode(keyboardController: keyboardController, valueType: ValueUtil.VALUE_TYPE.lowercase)
            VisualUtil.updateView(letter: keyboardController.currentValues.getCurrentValue())
            SpeechUtil.speak(textToSpeak: "Current letter lower cased")
        }
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
    
    func onTwoTouchHold(){
        var text = ""
        if (currentWord != ""){
            text = "Current word: " + currentWord
        }
        else {
            text = "No letters in current word yet."
        }
        SpeechUtil.speak(textToSpeak: text)
    }
    

    
    private func loadFromProxy() -> String {
        let textInDocumentProxy : [String] = keyboardController.textDocumentProxy.documentContextBeforeInput!.components(separatedBy: " ").filter{$0.isEmpty == false}
        return textInDocumentProxy.isEmpty ? "" : textInDocumentProxy.last!
    }
}
