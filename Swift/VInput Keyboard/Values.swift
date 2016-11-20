//
//  Keyboard.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation


protocol Values {
    
    var values : [String] { get }
    
    var leftBound : Int { get }
    
    var rightBound : Int { get }
    
    var leftIndex : Int { get set }
    
    var rightIndex : Int { get set }
    
}

extension Values {
    
    func getCurrentValue() -> String {
        return values[Int(ceil(Double(rightIndex - leftIndex)/2)) + leftIndex - 1]
    }
    
    mutating func shiftLeft() {
        self.rightIndex = Int(ceil(Double(rightIndex - leftIndex)/2)) + leftIndex - 1
    }
    
    mutating func shiftRight() {
        self.leftIndex += Int(ceil(Double(rightIndex - leftIndex)/2.0))
    }
    
    //TO-DO: Refactor this --> Mike
    mutating func isSearchingThenReset() -> Bool {
        if leftIndex != leftBound || rightIndex != rightBound {
            leftIndex = leftBound
            rightIndex = rightBound
            return true
        }
        return false
    }

    func isDone() -> Bool {
        return leftIndex == rightIndex
    }
}
