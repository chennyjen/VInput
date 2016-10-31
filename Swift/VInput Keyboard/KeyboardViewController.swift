//
//  KeyboardViewController.swift
//  VInput Keyboard
//
//  Created by McClish, Thomas on 10/27/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import UIKit
import AVFoundation

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    var fullView: UIView!
    var letterLabel: UILabel!
    let singleTapRecognizer = UITapGestureRecognizer()
    let doubleTapRecognizer = UITapGestureRecognizer()
    let doubleTapTwoTouchRecognizer = UITapGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    //let panFromTopRecognizer = UIScreenEdgePanGestureRecognizer() - have to suppress opening notification center for this to work
    let pinchRecognizer = UIPinchGestureRecognizer()
    let holdRecognizer = UILongPressGestureRecognizer()
    var heightConstraint: NSLayoutConstraint?
    let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                              "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var word: String = ""
    var lIndex = 0
    var rIndex = 25
    var utterance: AVSpeechUtterance!
    let speechSynthesizer = AVSpeechSynthesizer()
    
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
        letterLabel = UILabel()
        letterLabel.font = letterLabel.font.withSize(fullView.frame.height - nextKeyboardButton.frame.height)
        letterLabel.adjustsFontSizeToFitWidth = true
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        fullView.addSubview(letterLabel)
        letterLabel.centerXAnchor.constraint(equalTo: fullView.centerXAnchor).isActive = true
        letterLabel.centerYAnchor.constraint(equalTo: fullView.centerYAnchor).isActive = true
        letterLabel.textColor = UIColor.black
        rewrite()
        
        // Set gesture recognizer targets and values
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.addTarget(self, action: #selector(onSingleTap))
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        
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
        
        holdRecognizer.minimumPressDuration = TimeInterval(1)
        holdRecognizer.allowableMovement = 50
        holdRecognizer.addTarget(self, action: #selector(onHold))
        
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
        fullView.addGestureRecognizer(holdRecognizer)
        
        // TODO fix this to check for orientation and set constraint to desired value
        heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 256)
        
        heightConstraint!.priority = 999.0
    }
    
    func onSingleTap() {
        print("--- Single Tapped")
    }
    
    func onDoubleTap() {
        speak(textToSpeak: word)
    }
    
    func onDoubleTapTwoTouch() {
        for character in word.characters {
            speak(textToSpeak: String(character))
        }
    }
    
    // navigate left
    func onSwipeLeft() {
        rIndex = Int(ceil(Double(rIndex - lIndex)/2)) + lIndex - 1
        checkDone()
    }
    
    func onSwipeDown() {
        (textDocumentProxy as UIKeyInput).deleteBackward()
        word.remove(at: word.index(before: word.endIndex))
        speak(textToSpeak: "backspace")
    }
    
    // navigate right
    func onSwipeRight() {
        lIndex += Int(ceil(Double(rIndex - lIndex)/2.0))
        checkDone()
    }
    
    func onSwipeUp() {
        lIndex = Int(ceil(Double(rIndex - lIndex)/2)) + lIndex - 1
        rIndex = lIndex
        checkDone()
    }
    
//    func onPanFromTop() {
//        self.dismissKeyboard()
//    }
    
    func onPinch() {
        if pinchRecognizer.state == UIGestureRecognizerState.ended {
            self.dismissKeyboard()
        }
    }
    
    func onHold() {
        if holdRecognizer.state == UIGestureRecognizerState.began {
            (textDocumentProxy as UIKeyInput).insertText(" ")
            speak(textToSpeak: "space")
            word = ""
        }
    }
    
    func checkDone() {
        if(lIndex == rIndex)
        {
            (textDocumentProxy as UIKeyInput).insertText(alphabet[lIndex])
            word += alphabet[lIndex]
            // speak with a lower pitch when announcing a finalized letter,
            // and put a one second delay after speech so call to rewrite 
            // doesn't immediately speak the next option
            speak(textToSpeak: alphabet[lIndex], pitchMultiplier: 0.75, postDelay: TimeInterval(0.5))
            lIndex = 0
            rIndex = 25
        }
        else
        {
            print(alphabet[lIndex], "to", alphabet[rIndex])
        }
        rewrite()
    }
    
    func rewrite() {
        let nextMid = Int(ceil(Double(rIndex - lIndex)/2)) + lIndex - 1
        letterLabel.text = alphabet[nextMid]
        speak(textToSpeak: alphabet[nextMid])
    }
    
    func speak(textToSpeak: String, pitchMultiplier: Float = 1.0, postDelay: TimeInterval = TimeInterval(0)) {
        utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.pitchMultiplier = pitchMultiplier
        utterance.postUtteranceDelay = postDelay
        speechSynthesizer.speak(utterance)
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
