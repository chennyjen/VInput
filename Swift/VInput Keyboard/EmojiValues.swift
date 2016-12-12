//
//  EmojiKeyboard.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class EmojiValues : Values {
    
    let emojiValues : [String] = ["😃","😊","😬","😐","☹","😭","😡"]
    var index: Int
    var valueType: ValueUtil.VALUE_TYPE
    
    init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .emoji) {
        self.index = 0
        self.valueType = .emoji
    }
    
    func shiftLeft()
    {
        if index > 0
        {
            index -= 1
        }
    }
    
    func shiftRight()
    {
        if index < emojiValues.count - 1
        {
            index += 1
        }
    }
    
    func getCurrentValue() -> String
    {
        return emojiValues[index]
    }
    
    func resetIndexes()
    {
        index = 0
    }
    
    func getLeftIndex() -> Int
    {
        return index
    }
    
    func getRightIndex() -> Int
    {
        return index
    }
    
    func isSearchingResetAndAnounce() -> Bool
    {
        if index != 0 {
            index = 0
            return true
        }
        return false
    }
    
    func getValueType() -> ValueUtil.VALUE_TYPE
    {
        return valueType
    }
    
    func isDone() -> Bool
    {
        return index == (emojiValues.count - 1)
    }

}
