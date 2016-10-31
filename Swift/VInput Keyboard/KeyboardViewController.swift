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
    let singleTapRecognizer = UITapGestureRecognizer()
    let doubleTapRecognizer = UITapGestureRecognizer()
    let swipeLeftRecognizer = UISwipeGestureRecognizer()
    let swipeDownRecognizer = UISwipeGestureRecognizer()
    let swipeRightRecognizer = UISwipeGestureRecognizer()
    let swipeUpRecognizer = UISwipeGestureRecognizer()
    var heightConstraint: NSLayoutConstraint?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
        if (self.view.frame.size.width == 0 || self.view.frame.size.height == 0) {
            return
        }
        
        view.removeConstraint(heightConstraint!)
        
        heightConstraint!.constant = UIScreen.main.bounds.size.height * 0.9
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
        
        // Set gesture recognizer targets and values
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.addTarget(self, action: #selector(onSingleTap))
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.addTarget(self, action: #selector(onDoubleTap))
        
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        swipeLeftRecognizer.addTarget(self, action: #selector(onSwipeLeft))
        
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeDownRecognizer.addTarget(self, action: #selector(onSwipeDown))
        
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        swipeRightRecognizer.addTarget(self, action: #selector(onSwipeRight))
        
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up
        swipeUpRecognizer.addTarget(self, action: #selector(onSwipeUp))
        
        // Add gesture recognizers to fullView
        fullView.addGestureRecognizer(doubleTapRecognizer)
        fullView.addGestureRecognizer(singleTapRecognizer)
        fullView.addGestureRecognizer(swipeLeftRecognizer)
        fullView.addGestureRecognizer(swipeDownRecognizer)
        fullView.addGestureRecognizer(swipeRightRecognizer)
        fullView.addGestureRecognizer(swipeUpRecognizer)
        
        // Default Next Keyboard button
         nextKeyboardButton = UIButton(type: .system)
         nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
         nextKeyboardButton.sizeToFit()
         nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
         nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
         fullView.addSubview(nextKeyboardButton)
         nextKeyboardButton.leftAnchor.constraint(equalTo: fullView.leftAnchor).isActive = true
         nextKeyboardButton.bottomAnchor.constraint(equalTo: fullView.bottomAnchor).isActive = true
        
        // TODO fix this to check for orientation and set constraint to desired value
        heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 256)
        
        heightConstraint!.priority = 999.0
    }
    
    /*
     PSEUDOCODE FOR "BINARY SEARCH"
     ---------------------------------------------------------------------------
     alphabet = ["A", "B", "C", ... "Y", "Z"]
     
     func resetAlphabet() {
        alphabet = ["A", "B", "C", ... "Y", "Z"]
     }
     
     func processSwipe(swipeDirection) {
        alphabet = ["A", "B", "C", ... "Y", "Z"]
        if swipeDirection == "left {
            alphabet = left side of alphabet
        } else if swipeDirection == "right" {
            alphabet = right side of alphabet
        }
     }
     
     func getCenter() {
        return middle character of current alphabet
     }
     
    CHANGING INDEX VERSION (MIKE)
     var left_index
     var right_index
    
     func left() {
        right_index = (left_index + right_index) / 2 - 1
     }
     func right() {
        left_index = (left_index + right_index) / 2 + 1
     }
     func reset() {
        left_bound = 0
        right_bound = alphabet.size
        
     }
     */
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func onSingleTap(){
        print("--- Single Tapped")
    }
    
    func onDoubleTap(){
        print("--- Double Tapped")
        
        // Speaking test: speak everything that's been inputed
        let speechUtterance = AVSpeechUtterance(string: self.textDocumentProxy.documentContextBeforeInput!)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func onSwipeLeft(){
        print("--- Swipe Left")
        
    }
    
    func onSwipeDown(){
        // backspace character
        print("--- Swipe Down")
        
        // TODO: verbosity level: should it read 'deleted x character'?
        self.textDocumentProxy.deleteBackward()
    }
    
    func onSwipeRight(){
        print("--- Swipe Right")
    }
    
    func onSwipeUp(){
        // insert current character into buffer
        print("--- Swipe Up")

        // get character user has swiped to
        let currentCharacter = "c "
        
        // insert current character into
        self.textDocumentProxy.insertText(currentCharacter)
        
        // TODO: Use for reading back words
        // print(self.textDocumentProxy.documentContextBeforeInput!)
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
