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
    
    init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .lowercase) {
        self.values = values
        self.valueType = valueType
        self.leftBound = 0
        self.rightBound = self.values.count - 1
        self.leftIndex = self.leftBound
        self.rightIndex = self.rightBound
    }
    
    func getCurrentValue() -> String {
        if isDone() {
            return values[rightIndex]
        }
        return values[Int(ceil(Double(rightIndex - leftIndex)/2)) + leftIndex - 1]
    }
    
    func getValueType() -> ValueUtil.VALUE_TYPE {
        return valueType
    }
    
    func shiftLeft() {
        if rightIndex > leftIndex {
            self.rightIndex = Int(ceil(Double(rightIndex - leftIndex)/2)) + leftIndex - 1
        }
    }
    
    func shiftRight() {
        if leftIndex < rightIndex {
            self.leftIndex += Int(ceil(Double(rightIndex - leftIndex)/2.0))
        }
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
    
    func isDone() -> Bool {
        return leftIndex == rightIndex
    }
    
}
