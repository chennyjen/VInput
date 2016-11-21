//
//  CapitalAlphaValues.swift
//  VInput
//
//  Created by Michael Vander Lugt on 11/20/16.
//  Copyright © 2016 EECS481-VInput. All rights reserved.
//

import Foundation

class CapitalAlphaValues : InsertableValues {
    var capitalAlphaValues: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
                                 "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override init(values: [String] = [], valueType: ValueUtil.VALUE_TYPE = .uppercase) {
        super.init(values: capitalAlphaValues, valueType: valueType)
    }
}
