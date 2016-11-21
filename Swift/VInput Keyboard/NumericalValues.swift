//
//  NumericalValues.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/21/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class NumericalValues : InsertableValues {
    var numericalValues: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
                                 "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    override init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .numerical) {
        super.init(values: numericalValues)
    }
}
