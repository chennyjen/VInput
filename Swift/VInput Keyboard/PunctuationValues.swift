//
//  Punctuation.swift
//  VInput
//
//  Created by Michael Vander Lugt on 12/10/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class PunctuationValues : Values {
    
    let puncutationValues : [String] = [".","/",",","!","@","#","$","%", "^","&", "*", "(", ")"]
//    let emojiValueNames: [String] = ["Angry", "Sad", "Neutral", "Grinning", "Very Happy"]
    var index: Int
    var valueType: ValueUtil.VALUE_TYPE
    
    init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .punctuation)
    {
        self.index = 0
        self.valueType = .punctuation
    }
    
    func shiftLeft()
    {
        if index > 0
        {
            index -= 1
        }
    }
    
    func shiftRight() {
        if index < puncutationValues.count - 1
        {
            index += 1
        }
    }
    
    func getCurrentValue() -> String
    {
        return puncutationValues[index]
    }
    
    func resetIndexes() {
        index = 0
    }
    
    func getLeftIndex() -> Int {
        return index
    }
    
    func getRightIndex() -> Int {
        return index
    }
    
    func isSearchingResetAndAnounce() -> Bool {
        if index != 0 {
            index = 0
            return true
        }
        return false
    }
    
    func getValueType() -> ValueUtil.VALUE_TYPE {
        return valueType
    }
    
    func isDone() -> Bool {
        return index == (puncutationValues.count - 1)
    }
    
}
