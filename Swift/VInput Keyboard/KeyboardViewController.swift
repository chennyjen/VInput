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
    let twoTouchTapRecognizer = UITapGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    let twoFingerSwipeRightRecognizer = UISwipeGestureRecognizer()
    let threeFingerSwipeRightRecognizer = UISwipeGestureRecognizer()
    //let panFromTopRecognizer = UIScreenEdgePanGestureRecognizer() - have to suppress opening notification center for this to work
    let pinchRecognizer = UIPinchGestureRecognizer()
    let shortHoldRecognizer = UILongPressGestureRecognizer()
    let longHoldRecognizer = UILongPressGestureRecognizer()
    let twoTouchHoldRecognizer = UILongPressGestureRecognizer()
    var heightConstraint: NSLayoutConstraint?
    
    
    //TO-DO: This is a place holder for now. Dynamic generation coming soon -> Mike
    var currentValues: Values = LowerAlphaValues()
    var currentMode: Mode? = nil
    
    var persistentContainer: NSPersistentContainer?

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
//            TrainingMode(values: currentValues, keyboardController: self, key: Key(trainingStrings: ["testing", "twice"], callingMode: .tutorial))
        
        
        // Perform custom UI setup here
        // Set up UIView over full area to accept gestures
        fullView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        fullView.frame = self.view.bounds;
        fullView.accessibilityTraits = UIAccessibilityTraitAllowsDirectInteraction
        fullView.isAccessibilityElement = true
        fullView.backgroundColor = UIColor.clear
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
        nextKeyboardButton.addTarget(self, action: #selector(UIInputViewController.advanceToNextInputMode), for: .allTouchEvents)
        nextKeyboardButton.backgroundColor = .clear
        nextKeyboardButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        nextKeyboardButton.layer.cornerRadius = 5
        nextKeyboardButton.layer.borderWidth = 1
        nextKeyboardButton.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        nextKeyboardButton.titleLabel!.font = UIFont.systemFont(ofSize: 24)
        nextKeyboardButton.accessibilityTraits = UIAccessibilityTraitNone
        fullView.addSubview(nextKeyboardButton)
        nextKeyboardButton.centerXAnchor.constraint(equalTo: fullView.centerXAnchor).isActive = true
        nextKeyboardButton.bottomAnchor.constraint(equalTo: fullView.bottomAnchor, constant: -20).isActive = true
        
        // Add label for current midpoint letter
        KeyboardViewController.letterLabel = UILabel()
        KeyboardViewController.letterLabel.font = UIFont.boldSystemFont(ofSize: 136)
        KeyboardViewController.letterLabel.adjustsFontSizeToFitWidth = true
        KeyboardViewController.letterLabel.translatesAutoresizingMaskIntoConstraints = false
        fullView.addSubview(KeyboardViewController.letterLabel)
        KeyboardViewController.letterLabel.centerXAnchor.constraint(equalTo: fullView.centerXAnchor).isActive = true
        KeyboardViewController.letterLabel.centerYAnchor.constraint(equalTo: fullView.centerYAnchor).isActive = true
        KeyboardViewController.letterLabel.textColor = UIColor.black
        
        //TO-DO: PLACE HOLDER FOR NOW -> Mike
        
//         Set gesture recognizer targets and values
//        singleTapRecognizer.numberOfTapsRequired = 1
//        singleTapRecognizer.addTarget(self, action: #selector(onSingleTap))
//        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        doubleTapRecognizer.addTarget(self, action: #selector(onDoubleTap))
        doubleTapRecognizer.require(toFail: doubleTapTwoTouchRecognizer)
        
        twoTouchTapRecognizer.numberOfTapsRequired = 1
        twoTouchTapRecognizer.numberOfTouchesRequired = 2
        twoTouchTapRecognizer.addTarget(self, action: #selector(onTwoTouchTap))
        twoTouchTapRecognizer.require(toFail: doubleTapTwoTouchRecognizer)
        
        doubleTapTwoTouchRecognizer.numberOfTapsRequired = 2
        doubleTapTwoTouchRecognizer.numberOfTouchesRequired = 2
        doubleTapTwoTouchRecognizer.addTarget(self, action: #selector(onDoubleTapTwoTouch))
        
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        swipeLeftRecognizer.addTarget(self, action: #selector(onSwipeLeft))
        
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeDownRecognizer.addTarget(self, action: #selector(onSwipeDown))
        
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        swipeRightRecognizer.addTarget(self, action: #selector(onSwipeRight))
        
        twoFingerSwipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        twoFingerSwipeRightRecognizer.numberOfTouchesRequired = 2
        twoFingerSwipeRightRecognizer.addTarget(self, action: #selector(onTwoFingerSwipeRight))
        twoFingerSwipeRightRecognizer.require(toFail: swipeRightRecognizer)
        
        threeFingerSwipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        threeFingerSwipeRightRecognizer.numberOfTouchesRequired = 3
        threeFingerSwipeRightRecognizer.addTarget(self, action: #selector(onThreeFingerSwipeRight))
        threeFingerSwipeRightRecognizer.require(toFail: twoFingerSwipeRightRecognizer)
        
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeUpRecognizer.addTarget(self, action: #selector(onSwipeUp))
        
        //panFromTopRecognizer.edges.insert(UIRectEdge.top)
        //panFromTopRecognizer.addTarget(self, action: #selector(onPanFromTop))
        
        pinchRecognizer.addTarget(self, action: #selector(onPinch))
        pinchRecognizer.require(toFail: twoFingerSwipeRightRecognizer)
        pinchRecognizer.require(toFail: threeFingerSwipeRightRecognizer)
        
        shortHoldRecognizer.minimumPressDuration = TimeInterval(1)
        shortHoldRecognizer.allowableMovement = 50
        shortHoldRecognizer.addTarget(self, action: #selector(onHold))
        shortHoldRecognizer.require(toFail: longHoldRecognizer)
        
        longHoldRecognizer.minimumPressDuration = TimeInterval(4)
        longHoldRecognizer.numberOfTouchesRequired = 1
        longHoldRecognizer.allowableMovement = 50
        longHoldRecognizer.addTarget(self, action: #selector(onLongHold))
        //longHoldRecognizer.require(toFail: shortHoldRecognizer)
        
        twoTouchHoldRecognizer.numberOfTouchesRequired = 2
        twoTouchHoldRecognizer.minimumPressDuration = TimeInterval(1)
        twoTouchHoldRecognizer.allowableMovement = 50
        twoTouchHoldRecognizer.addTarget(self, action: #selector(onTwoTouchHold))
        twoTouchHoldRecognizer.require(toFail: shortHoldRecognizer)
        //twoTouchHoldRecognizer.delaysTouchesBegan = true
        
        // Add gesture recognizers to fullView
        fullView.addGestureRecognizer(doubleTapRecognizer)
        fullView.addGestureRecognizer(twoTouchTapRecognizer)
        fullView.addGestureRecognizer(doubleTapTwoTouchRecognizer)
        fullView.addGestureRecognizer(singleTapRecognizer)
        fullView.addGestureRecognizer(swipeLeftRecognizer)
        fullView.addGestureRecognizer(swipeDownRecognizer)
        fullView.addGestureRecognizer(swipeRightRecognizer)
        fullView.addGestureRecognizer(swipeUpRecognizer)
        fullView.addGestureRecognizer(twoFingerSwipeRightRecognizer)
        fullView.addGestureRecognizer(threeFingerSwipeRightRecognizer)
        //fullView.addGestureRecognizer(panFromTopRecognizer)
        fullView.addGestureRecognizer(pinchRecognizer)
        fullView.addGestureRecognizer(shortHoldRecognizer)
        fullView.addGestureRecognizer(longHoldRecognizer)
        fullView.addGestureRecognizer(twoTouchHoldRecognizer)
        
        // TODO fix this to check for orientation and set constraint to desired value
        heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 256)
        
        heightConstraint!.priority = 999.0
        
        // Setup Core Data container
        persistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSPersistentContainer(name: "Prediction")
            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            var containerPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.VInput")!
            containerPath = URL(fileURLWithPath: documentsDirectory.appending("/store.sqlite"), isDirectory: false)
//            containerPath = containerPath.appendingPathComponent("store.sqlite")
            do {
                try FileManager.default.removeItem(at: containerPath)
            } catch {
                // nothing
                print("Could not delete CD DB")
            }
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
        
        // Focus VO on VInput keyboard
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, fullView)
        
        // EXAMPLES OF INSERTING WORDS INTO CORE DATA
//        let context = persistentContainer!.viewContext
//        if let word = NSEntityDescription.insertNewObject(forEntityName: "TypedWord", into: context) as? TypedWord {
//            word.word = "Ryan"
//            word.frequency = 100
//        }
//        if let word = NSEntityDescription.insertNewObject(forEntityName: "TypedWord", into: context) as? TypedWord {
//            word.word = "Mike"
//            word.frequency = 90
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentMode = InputMode(keyboardController: self)
        SpeechUtil.speak(textToSpeak: "Vinput Keyboard", preDelay: 0.5)
        currentMode!.initialize()
    }
    
    func onDoubleTap() {
        SpeechUtil.stopSpeech()
        currentMode!.doubleTap()
    }
    
//  TODO: Migrate Over -> Mike
    func onDoubleTapTwoTouch() {
//        for character in word.characters {
//            speak(textToSpeak: String(character))
//        }
        //SpeechUtil.speak(textToSpeak: "Two touch recognized")
    }
    
    func onTwoTouchTap() {
        SpeechUtil.stopSpeech()
        currentMode!.onTwoTouchTap()
    }

    func onSwipeLeft() {
        SpeechUtil.stopSpeech()
        currentMode!.onSwipeLeft()
    }
    
    func onSwipeDown() {
        SpeechUtil.stopSpeech()
        currentMode!.swipeDown()
    }
    
    func onSwipeRight() {
        SpeechUtil.stopSpeech()
        currentMode!.onSwipeRight()
    }
    
    func onSwipeUp() {
        SpeechUtil.stopSpeech()
        currentMode!.onSwipeUp()
    }
    
//    func onPanFromTop() {
//        self.dismissKeyboard()
//    }
    
    func onPinch() {
        SpeechUtil.stopSpeech()
        if pinchRecognizer.state == UIGestureRecognizerState.ended {
            self.dismissKeyboard()
        }
    }
    
    func onHold() {
        if shortHoldRecognizer.state == UIGestureRecognizerState.began {
            SpeechUtil.stopSpeech()
            currentMode!.onHold()
        }
    }
    
    func onLongHold() {
        if longHoldRecognizer.state == UIGestureRecognizerState.began {
            //SpeechUtil.speak(textToSpeak: "Long Hold recognized")
            SpeechUtil.stopSpeech()
            currentMode!.onLongHold()
        }
    }
    
    func onTwoTouchHold(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            SpeechUtil.stopSpeech()
            currentMode!.onTwoTouchHold()
        }
    }
    
    func onTwoFingerSwipeRight() {
        SpeechUtil.stopSpeech()
        currentMode!.onTwoFingerSwipeRight()
    }
    
    func onThreeFingerSwipeRight() {
        SpeechUtil.stopSpeech()
        // Renable normalVO functionality and allow user to transition 
        // to another keyboard
        fullView.accessibilityTraits = UIAccessibilityTraitNone
        fullView.isAccessibilityElement = false
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nextKeyboardButton)
    }

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
