//
//  ValueUtil.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/21/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class ValueUtil {
    
    enum VALUE_TYPE: Int
    {
        case lowercase = 0
        case uppercase
        case numerical
        case emoji
        case punctuation
        
        func numValueTypes() -> Int {
            //This is bad b/c hardcoded, but it's not like it even matters
            return VALUE_TYPE.punctuation.rawValue
        }
        
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
        case .punctuation:
            toSwap = PunctuationValues()
        default:
            toSwap = NumericalValues()
        }
        keyboardController.currentValues = toSwap!
    }
}
