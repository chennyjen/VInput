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
        
        //        SEARCHING FOR WORD
        //        let request = NSFetchRequest<NSFetchRequestResult>()
        //        request.predicate = NSPredicate(format: "word beginswith[c] %@", word)
        //        request.entity = NSEntityDescription.entity(forEntityName: "TypedWord", in: context)
        //
        //        do {
        //            let results = try context.fetch(request)
        //            if results.count > 0 {
        //                // suggestion = results[0]
        //            }
        //
        //        } catch {
        //            let fetchError = error as NSError
        //            print(fetchError)
        //        }
        // if word in DB, increment
        // else
        // add to DB and increment
        
        //Not sure if this should be here
        values.isSearchingThenReset()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())

    }
    
    private func loadFromProxy() -> String {
        let textInDocumentProxy : [String] = keyboardController.textDocumentProxy.documentContextBeforeInput!.components(separatedBy: " ").filter{$0.isEmpty == false}
        return textInDocumentProxy.isEmpty ? "" : textInDocumentProxy.last!
    }
}