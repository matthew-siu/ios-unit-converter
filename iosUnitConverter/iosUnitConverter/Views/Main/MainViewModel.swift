//
//  MainViewModel.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 17/1/2025.
//

import Foundation

class MainViewModel: ObservableObject{
    
    @Published var selectedMeasurement: MeasurementType
    @Published var inputValue: String = ""
    @Published var outputValue: String = "0"
    @Published var selectedInputUnit: Dimension
    @Published var selectedOutputUnit: Dimension
    
    let measurementTypes: [MeasurementType] = [
        Eggs(),
        Length(),
        Weight(),
        Volume(),
        Temperature(),
        Area()
    ]
    
    var isEggsSelected: Bool {
        selectedMeasurement is Eggs
    }
    
    init() {
        selectedMeasurement = measurementTypes.first!
        selectedInputUnit = measurementTypes.first!.defaultInput
        selectedOutputUnit = measurementTypes.first!.defaultOutput
        
        self.selectMeasurement(new: measurementTypes.first!)
    }
    
    func selectMeasurement(new: MeasurementType){
        selectedMeasurement = new
        selectedInputUnit = new.defaultInput
        selectedOutputUnit = new.defaultOutput
    }
    
    func selectMeasurement(deeplink: String){
        if let type = measurementTypes.first(where: { $0.deeplinkPath == deeplink }){
            selectMeasurement(new: type)
            
        }else {
            print("Invalid Deeplink: \(deeplink)")
            
        }
    }
    
    func swapInputAndOutputUnit(){
        let tmp = selectedInputUnit
        selectedInputUnit = selectedOutputUnit
        selectedOutputUnit = tmp
    }
    
    func calculateConversion() {
        guard let input = Double(inputValue) else {
            outputValue = "0"
            return
        }

        var convertedValue: Double = 0
//        if let measurement = selectedMeasurement as? Eggs{
//            convertedValue = measurement.convert(value: input, from: selectedInputUnit, to: selectedInputUnit)
//        }else{
            let inputUnit = selectedInputUnit
            let outputUnit = selectedOutputUnit
            convertedValue = selectedMeasurement.convert(value: input, from: inputUnit, to: outputUnit)
//        }

        // Format the output: 2 decimal places for small numbers, fixed-point for others
        if convertedValue > 0.01 {
            outputValue = String(format: "%.2f", convertedValue) // 2 decimal places
        } else {
            outputValue = String(format: "%.3g", convertedValue) // 3 significant figures
        }
        print("convert \(inputValue)\(selectedInputUnit.symbol) = \(outputValue)\(selectedOutputUnit.symbol)")
    }
}
