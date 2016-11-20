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
        self.currentWord = self.loadFromProxy()
//        keyboardController.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
//        SpeechUtil.speak(textToSpeak: self.loadFromProxy())
        SpeechUtil.speak(textToSpeak: keyboardController.textDocumentProxy.documentContextBeforeInput!)
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
        let text = "Left or right of " + values.getCurrentValue()
        keyboardController.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
        SpeechUtil.speak(textToSpeak: loadFromProxy())
    }
    
    func onHold() {
        //Reset search here?
        keyboardController.textDocumentProxy.insertText(" ")
        currentWord = ""
        SpeechUtil.speak(textToSpeak: "Inserting space")
        
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
    }
    
    private func loadFromProxy() -> String {
        let textInDocumentProxy : [String] = keyboardController.textDocumentProxy.documentContextBeforeInput!.components(separatedBy: " ").filter{$0.isEmpty == false}
        return textInDocumentProxy.isEmpty ? "" : textInDocumentProxy.last!
    }
}
