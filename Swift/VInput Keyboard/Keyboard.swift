//
//  Keyboard.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/6/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//


protocol Keyboard {
    
    var leftIndex: Int { get set }
    
    var rightIndex: Int { get set }
    
    var leftBaseIndex: Int { get }
    
    var rightBaseIndex: Int { get }
    
    var keyboardValues : [Character] { get }
    
    func getSelectedCharacter() -> Character

}
