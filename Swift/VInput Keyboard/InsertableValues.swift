//
//  InsertableValues.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/20/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class InsertableValues : Values {
    
    var values : [String]
    
    var valueType: ValueUtil.VALUE_TYPE
    
    var leftBound : Int
    
    var rightBound : Int
    
    var leftIndex : Int
    
    var rightIndex : Int
    
    init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE) {
        self.values = values
        self.valueType = valueType
        self.leftBound = 0
        self.rightBound = self.values.count - 1
        self.leftIndex = self.leftBound
        self.rightIndex = self.rightBound
    }
    
    //TO-DO: Check how the subclass initializers use this. Proven to be safe, but unsure if valueType needs to be forced -> Mike
    convenience init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE, presetLeftIndex: Int, presetRightIndex: Int) {
        self.init(values: values, valueType: valueType)
        self.leftIndex = presetLeftIndex
        self.rightIndex = presetRightIndex
    }
    
    func getCurrentValue() -> String {
        return values[Int(ceil(Double(rightIndex - leftIndex)/2)) + leftIndex - 1]
    }
    
    func getValueType() -> ValueUtil.VALUE_TYPE {
        return valueType
    }
    
    func shiftLeft() {
        self.rightIndex = Int(ceil(Double(rightIndex - leftIndex)/2)) + leftIndex - 1
    }
    
    func shiftRight() {
        self.leftIndex += Int(ceil(Double(rightIndex - leftIndex)/2.0))
    }
    
    //TO-DO: Refactor this --> Mike
    func isSearchingResetAndAnounce() -> Bool {
        if leftIndex != leftBound || rightIndex != rightBound {
            resetIndexes()
            SpeechUtil.speak(textToSpeak: "Restarting Search")
            return true
        }
        return false
    }
    
    func resetIndexes() {
        leftIndex = leftBound
        rightIndex = rightBound
    }
    
    func getLeftIndex() -> Int {
        return leftIndex
    }
    
    func getRightIndex() -> Int {
        return rightIndex
    }
    
    func isDone() -> Bool {
        return leftIndex == rightIndex
    }
    
}
