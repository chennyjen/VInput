//
//  ValueUtil.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/21/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class ValueUtil {
    
    enum VALUE_TYPE
    {
        case numerical
        case lowercase
        case uppercase
        case emoji
        case training
    }

    static func swapMode(keyboardController: KeyboardViewController, valueType: VALUE_TYPE)
    {
        var toSwap: Values? = nil
        switch valueType {
        case .lowercase:
            //TO-DO: check if these need to be passed valueType -> Mike
            toSwap = LowerAlphaValues(valueType: .lowercase, presetLeftIndex: keyboardController.currentValues.getLeftIndex(), presetRightIndex: keyboardController.currentValues.getRightIndex())
        case .uppercase:
            toSwap = CapitalAlphaValues(valueType: .uppercase, presetLeftIndex: keyboardController.currentValues.getLeftIndex(), presetRightIndex: keyboardController.currentValues.getRightIndex())
        case .emoji:
            toSwap = EmojiValues()
        default:
            toSwap = NumericalValues()
        }
        keyboardController.currentValues = toSwap!
    }
}
