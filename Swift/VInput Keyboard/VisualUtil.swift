//
//  VisualUtil.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/17/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation
import UIKit

class VisualUtil {
    
    static func updateViewAndAnnounce(letter: String) {
        KeyboardViewController.letterLabel.text = letter
        let text = "Left or right of " + letter
        SpeachUtil.speak(textToSpeak: text)
    }
    
}
