//
//  EmojiKeyboard.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/16/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class EmojiValues : InsertableValues {
    
    let emojiValues : [String] = ["😡","☹","😐","😬","😃"]
    let emojiValueNames: [String] = ["Angry", "Sad", "Neutral", "Grinning", "Very Happy"]
    
    override init(values: [String] = []) {
        super.init(values: emojiValues)
    }
    
}
