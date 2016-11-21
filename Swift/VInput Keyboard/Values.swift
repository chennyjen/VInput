//
//  Keyboard.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation


protocol Values {
    
    func getCurrentValue() -> String
    
    func getValueType() -> ValueUtil.VALUE_TYPE
    
    func shiftLeft()
    
    func shiftRight()
    
    func isSearchingResetAndAnounce() -> Bool
    
    func resetIndexes()
    
    func isDone() -> Bool

}
