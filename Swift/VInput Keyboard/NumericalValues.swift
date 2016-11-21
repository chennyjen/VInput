//
//  NumericalValues.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/21/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class NumericalValues : InsertableValues {
    var numericalValues: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    override init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .numerical) {
        super.init(values: numericalValues, valueType: valueType)
    }
}
