//
//  KeyboardViewController.swift
//  VInput Keyboard
//
//  Created by McClish, Thomas on 10/27/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    var fullView: UIView!
    static var letterLabel: UILabel!
    let singleTapRecognizer = UITapGestureRecognizer()
    let doubleTapRecognizer = UITapGestureRecognizer()
    let doubleTapTwoTouchRecognizer = UITapGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    //let panFromTopRecognizer = UIScreenEdgePanGestureRecognizer() - have to suppress opening notification center for this to work
    let pinchRecognizer = UIPinchGestureRecognizer()
    let shortHoldRecognizer = UILongPressGestureRecognizer()
    let longHoldRecognizer = UILongPressGestureRecognizer()
    var heightConstraint: NSLayoutConstraint?
    let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                              "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var word: String = ""
    var lIndex = 0
    var rIndex = 25
    var insertedPeriod: Bool = false
    var utterance: AVSpeechUtterance!
    let speechSynthesizer = AVSpeechSynthesizer()
    var newWord: Bool = true
    
    //TO-DO: This is a place holder for now. Dynamic generation coming soon -> Mike
    var currentValues: Values = AlphaValues()
    var currentMode: Mode = TrainingMode() //Dummy for now

    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        if (self.view.frame.size.width == 0 || self.view.frame.size.height == 0) {
            return
        }
        
        view.removeConstraint(heightConstraint!)
        
        heightConstraint!.constant = UIScreen.main.bounds.size.height
        view.addConstraint(heightConstraint!)
        print("--- Set main view height to", heightConstraint?.constant)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TO-DO: This is a place holder for now -> Mike
        currentMode = InputMode(values: currentValues, keyboardController: self)
        
        
        // Perform custom UI setup here
        // Set up UIView over full area to accept gestures
        fullView = UIView()
        fullView.backgroundColor = UIColor.gray
        fullView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullView)
        fullView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        fullView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fullView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        fullView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // Default Next Keyboard button
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        fullView.addSubview(nextKeyboardButton)
        nextKeyboardButton.leftAnchor.constraint(equalTo: fullView.leftAnchor).isActive = true
        nextKeyboardButton.bottomAnchor.constraint(equalTo: fullView.bottomAnchor).isActive = true
        
        // Add label for current midpoint letter
        KeyboardViewController.letterLabel = UILabel()
        KeyboardViewController.letterLabel.font = KeyboardViewController.letterLabel.font.withSize(fullView.frame.height - nextKeyboardButton.frame.height)
        KeyboardViewController.letterLabel.adjustsFontSizeToFitWidth = true
        KeyboardViewController.letterLabel.translatesAutoresizingMaskIntoConstraints = false
        fullView.addSubview(KeyboardViewController.letterLabel)
        KeyboardViewController.letterLabel.centerXAnchor.constraint(equalTo: fullView.centerXAnchor).isActive = true
        KeyboardViewController.letterLabel.centerYAnchor.constraint(equalTo: fullView.centerYAnchor).isActive = true
        KeyboardViewController.letterLabel.textColor = UIColor.black
        
        //TO-DO: PLACE HOLDER FOR NOW -> Mike
        VisualUtil.updateViewAndAnnounce(letter: currentValues.getCurrentValue())
        
//         Set gesture recognizer targets and values
//        singleTapRecognizer.numberOfTapsRequired = 1
//        singleTapRecognizer.addTarget(self, action: #selector(onSingleTap))
//        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        doubleTapRecognizer.addTarget(self, action: #selector(onDoubleTap))
        doubleTapRecognizer.require(toFail: doubleTapTwoTouchRecognizer)
        
        doubleTapTwoTouchRecognizer.numberOfTapsRequired = 2
        doubleTapTwoTouchRecognizer.numberOfTouchesRequired = 2
        doubleTapTwoTouchRecognizer.addTarget(self, action: #selector(onDoubleTapTwoTouch))
        
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        swipeLeftRecognizer.addTarget(self, action: #selector(onSwipeLeft))
        
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeDownRecognizer.addTarget(self, action: #selector(onSwipeDown))
        
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        swipeRightRecognizer.addTarget(self, action: #selector(onSwipeRight))
        
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeUpRecognizer.addTarget(self, action: #selector(onSwipeUp))
        
        //panFromTopRecognizer.edges.insert(UIRectEdge.top)
        //panFromTopRecognizer.addTarget(self, action: #selector(onPanFromTop))
        
        pinchRecognizer.addTarget(self, action: #selector(onPinch))
        
        shortHoldRecognizer.minimumPressDuration = TimeInterval(1)
        shortHoldRecognizer.allowableMovement = 50
        shortHoldRecognizer.addTarget(self, action: #selector(onHold))
        
        // Add gesture recognizers to fullView
        fullView.addGestureRecognizer(doubleTapRecognizer)
        fullView.addGestureRecognizer(doubleTapTwoTouchRecognizer)
        fullView.addGestureRecognizer(singleTapRecognizer)
        fullView.addGestureRecognizer(swipeLeftRecognizer)
        fullView.addGestureRecognizer(swipeDownRecognizer)
        fullView.addGestureRecognizer(swipeRightRecognizer)
        fullView.addGestureRecognizer(swipeUpRecognizer)
        //fullView.addGestureRecognizer(panFromTopRecognizer)
        fullView.addGestureRecognizer(pinchRecognizer)
        fullView.addGestureRecognizer(shortHoldRecognizer)
        
        // TODO fix this to check for orientation and set constraint to desired value
        heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 256)
        
        heightConstraint!.priority = 999.0
        
        // CORE DATA http://stackoverflow.com/questions/37956720/how-to-create-managedobjectcontext-using-swift-3-in-xcode-8
        let persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "Prediction")
            let containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.VInput")!
            let description = NSPersistentStoreDescription(url: containerPath)
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        let context = persistentContainer.viewContext
        if let word = NSEntityDescription.insertNewObject(forEntityName: "TypedWord", into: context) as? TypedWord {
            word.word = "Ryan"
            word.frequency = 100
        }
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "TypedWord", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try context.executeFetchRequest(fetchRequest)
            print(result)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func onDoubleTap() {
        currentMode.doubleTap()
    }
    
//  TODO: Migrate Over -> Mike
    func onDoubleTapTwoTouch() {
//        for character in word.characters {
//            speak(textToSpeak: String(character))
//        }
    }

    func onSwipeLeft() {
        currentMode.onSwipeLeft()
    }
    
    //TODO: Migrate Over -> Mike
    func onSwipeDown() {
        currentMode.swipeDown()
//        if searching {
//            restartSearch()
//        }
//        else {
//            speak(textToSpeak: "Deleting previous character", postDelay: TimeInterval(4))
//            self.textDocumentProxy.deleteBackward()
//            announceLetter()
//        }
    }
    
    func onSwipeRight() {
        currentMode.onSwipeRight()
    }
    
    //TO-DO: Migrate functionality over -> Mike
    func onSwipeUp() {
        currentMode.onSwipeUp()
//        let mid = Int(ceil(Double(rIndex - lIndex)/2)) + lIndex - 1
//        self.textDocumentProxy.insertText(alphabet[mid])
//        word = newWord ? alphabet[mid] : word + alphabet[mid]
//        newWord = false
//        let text = alphabet[mid] + " inserted"
//        SpeachUtil.speak(textToSpeak: text, pitchMultiplier: 1.0, postDelay: TimeInterval(4))
//        restartSearch()
    }
    
//    func onPanFromTop() {
//        self.dismissKeyboard()
//    }
    
    //TODO: Figure out if this is necessary -> ?
    func onPinch() {
        if pinchRecognizer.state == UIGestureRecognizerState.ended {
            self.dismissKeyboard()
        }
    }
    
    //To-do: Migrate over -> Mike
    func onHold() {
//        if shortHoldRecognizer.state == UIGestureRecognizerState.began {
//            self.textDocumentProxy.insertText(" ")
//            newWord = true
//            speak(textToSpeak: "Space inserted")
//            
    // TODO when Settings bundle is implemented, this behavior should be a setting
//            if word == "" && !insertedPeriod {
//                (textDocumentProxy as UIKeyInput).deleteBackward()
//                (textDocumentProxy as UIKeyInput).insertText(". ")
//                speak(textToSpeak: "period inserted")
//                insertedPeriod = true
//            }
//            else {
//            }
//        }
    }

    //TO-DO: Migrate this functionaility to new code -> Mike
//    func isDone() -> Bool {
//        if(lIndex == rIndex)
//        {
//            // speak with a lower pitch when announcing a finalized letter,
//            // and put a one second delay after speech so call to rewrite 
//            // doesn't immediately speak the next option
//            let text = "Swipe up to select " + String(alphabet[lIndex]) + ", swipe down to restart search"
//            speak(textToSpeak: text, pitchMultiplier: 0.75, postDelay: TimeInterval(0.5))
//        }
//        return lIndex == rIndex
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("--- Rotated")
        updateViewConstraints()
    }
}
