//
//  Key.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/20/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

//TO-DO: Better class name! --> Mike

class Key {
    
    private let index: Int
    private let trainingStrings: [String]
    private let callingMode: ModeUtil.MODE
    
    
    init(index: Int = 0, trainingStrings: [String] = [], callingMode: ModeUtil.MODE) {
        self.index = index
        self.trainingStrings = trainingStrings
        self.callingMode = callingMode
    }
    
    func getIndex() -> Int {
        return index
    }
    
    func getStrings() -> [String] {
        return trainingStrings
    }
    
    func getMode() -> ModeUtil.MODE {
        return callingMode
    }
}
