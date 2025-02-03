//
//  ConvertedItem.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 22/1/2025.
//

import Foundation
import SwiftData

@Model
class ConvertedItem{
    var cts: Double
    var measurementType: String
    var inputValue: String
    var inputPerValue: String?
    var inputUnit: String
    var outputValue: String
    var outputPerValue: String?
    var outputUnit: String
    
    init(cts: Double, measurementType: String, inputValue: String, inputPerValue: String?, inputUnit: String, outputValue: String, outputPerValue: String?, outputUnit: String) {
        self.cts = cts
        self.measurementType = measurementType
        self.inputValue = inputValue
        self.inputPerValue = inputPerValue
        self.inputUnit = inputUnit
        self.outputValue = outputValue
        self.outputPerValue = outputPerValue
        self.outputUnit = outputUnit
    }
}
