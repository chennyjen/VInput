//
//  TutorialMode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation
import AVFoundation

class InputMode : Mode {
    
    var values: Values!
    let MODE_NAME = "InputMode"
    
    init(values: Values) {
        self.values = values
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
    }
    
    func swipeDown() {
        //TO-DO: Change this to be handled outside
        values.resetIfSearching()
        VisualUtil.updateViewAndAnnounce(letter: values.getCurrentValue())
    }
    
    func doubleTap() {
        let text = "Left or right of " + values.getCurrentValue()
        SpeachUtil.speak(textToSpeak: text)
    }
    
    func onHold() {
        // TO DO
    }
    
}
