//
//  Mode.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//
import Foundation

protocol Mode {
    
    func getModeName() -> String
    
    func onSwipeLeft()
    
    func onSwipeRight()
    
    func onSwipeUp()
    
    func onSwipeDown()
    
    func onDoubleTap()
    
    func onHold()
    
    
}
