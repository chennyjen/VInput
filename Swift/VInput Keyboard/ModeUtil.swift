//
//  ModeUtil.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/20/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class ModeUtil
{
    enum MODE {
        case training
        case tutorial
        case input
    }
    
    //TO-DO: Move mode over to an enum
    static func swapMode(keyboardController: KeyboardViewController, stateKey: Key, mode: MODE)
    {
        switch mode {
            case .training:
                keyboardController.currentMode = TrainingMode(values: keyboardController.currentValues, keyboardController: keyboardController, key: stateKey)
                keyboardController.currentMode!.initialize()
                break
            case .tutorial:
                keyboardController.currentMode = TutorialMode(values: keyboardController.currentValues, keyboardController: keyboardController, tutorialIndexState: stateKey.getIndex())
                keyboardController.currentMode!.initialize()
                break
            default: //Default to Input Mode
                return
        }
    }
}
