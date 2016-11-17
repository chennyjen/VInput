//
//  EmojiKeyboard.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class EmojiValues : Values {
    
    let values : [String] = ["😡","☹","😐","😬","😃"]
    let valueNames: [String] = ["Angry", "Sad", "Neutral", "Grinning", "Very Happy"]
    
    let leftBound: Int
    let rightBound: Int
    var leftIndex, rightIndex : Int
    
    init() {
        self.leftBound = 0
        self.rightBound = self.values.count - 1
        self.leftIndex = self.leftBound
        self.rightIndex = self.rightBound
    }
    
}
