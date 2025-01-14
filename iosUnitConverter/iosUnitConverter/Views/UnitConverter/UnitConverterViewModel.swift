//
//  UnitConverterViewModel.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 14/1/2025.
//

import Foundation

class UnitConverterViewModel: ObservableObject{
    @Published var item: any MeasurementType
    
    @Published var inputValue: String = ""
    @Published var outputValue: String = "0"
    @Published var selectedInputUnit: Dimension
    @Published var selectedOutputUnit: Dimension
    
    let measurementTypes: [any MeasurementType] = [
        Eggs(),
        Length(),
        Weight(),
        Volume(),
        Temperature(),
        Area(),
        CookingMeasurement()
    ]
    
    init(item: any MeasurementType) {
        self.item = item
        selectedInputUnit = item.units.first!
        selectedOutputUnit = item.units.first!
    }
    
    init(type: String) {
        if let matchingMeasurement = measurementTypes.first(where: { $0.name.lowercased() == type }) {
            self.item = matchingMeasurement
            selectedInputUnit = matchingMeasurement.units.first!
            selectedOutputUnit = matchingMeasurement.units.first!
        }else{
            let tmpMeasure = Length()
            self.item = tmpMeasure
            selectedInputUnit = tmpMeasure.units.first!
            selectedOutputUnit = tmpMeasure.units.first!
        }
    }
    
    var showOutputUnits: Bool {
        if let item = item as? Eggs {
            return false
        }else{
            return true
        }
    }
}
