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
    
    func initialize()
    
    func onSwipeLeft()
    
    func onSwipeRight()
    
    func onSwipeUp()
    
    func swipeDown()
    
    func doubleTap()
    
    func onHold()
    
    func onLongHold()
    
    func onTwoTouchTap()
    
    func onTwoTouchHold()
    
}
