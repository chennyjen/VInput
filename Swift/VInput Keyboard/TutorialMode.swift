//
//  TutorialMode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class TutorialMode : InputMode {
    
    override func onSwipeLeft() {
        SpeachUtil.speak(textToSpeak: "TESTING")
    }
    
    override func onSwipeRight() {
        return
    }
}
