//
//  Key.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/20/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

//TO-DO: BETTER FILE NAME

class Key {
    private let index: Int
    private let trainingStrings: [String]
    
    
    init(index: Int = 0, trainingStrings: [String] = []) {
        self.index = index
        self.trainingStrings = trainingStrings
    }
    
    func getIndex() -> Int {
        return index
    }
    
    func getStrings() -> [String] {
        return trainingStrings
    }
}
