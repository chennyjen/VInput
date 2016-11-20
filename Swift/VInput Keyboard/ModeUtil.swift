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
    //TO-DO: Move mode over to an enum
    static func swapMode(keyboardController: KeyboardViewController, stateKey: Key, mode: String)
    {
        switch mode {
            case "Input_Mode":
                keyboardController.currentMode = InputMode(values: keyboardController.currentValues,keyboardController:keyboardController)
            case "Training_Mode":
                return
            case "Tutorial_Mode":
                keyboardController.currentMode = TutorialMode(values: keyboardController.currentValues, keyboardController: keyboardController, tutorialIndexState: stateKey.getIndex())
            default: //Default to Input Mode
                return
        }
    }
}
