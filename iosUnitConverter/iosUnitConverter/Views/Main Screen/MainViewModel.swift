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
    @Published var inputPerValue: String = "1"
    @Published var outputValue: String = ""
    @Published var outputPerValue: String = "1"
    @Published var selectedInputUnit: Dimension
    @Published var selectedOutputUnit: Dimension
    
    @Published var priceMode = false
    
    let measurementTypes: [MeasurementType] = [
        Eggs(),
        Length(),
        Weight(),
        Volume(),
        Temperature(),
        Area()
    ]
    
    var isEggs: Bool{
        selectedMeasurement is Eggs
    }
    
    var isPriceMode: Bool {
        isEggs || priceMode
    }
    
    var showPerTextfield: Bool{
        !isEggs && priceMode
    }
    
    init() {
        selectedMeasurement = measurementTypes.first!
        selectedInputUnit = measurementTypes.first!.defaultInput
        selectedOutputUnit = measurementTypes.first!.defaultOutput
        
        let defaultType = measurementTypes.first(where: {$0 is Weight})!
        self.selectMeasurement(new: defaultType)
    }
    
    func selectMeasurement(new: MeasurementType){
        selectedMeasurement = new
        selectedInputUnit = new.defaultInput
        selectedOutputUnit = new.defaultOutput
        inputPerValue = "1"
        outputPerValue = "1"
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
        if priceMode {
            self.calculatePrice()
            return
        }
        guard let input = Double(inputValue) else {
            outputValue = "0"
            return
        }

        var convertedValue: Double = 0
        convertedValue = selectedMeasurement.convert(value: input, from: selectedInputUnit, to: selectedOutputUnit)

        // Format the output: 2 decimal places for small numbers, fixed-point for others
        if convertedValue > 0.01 {
            outputValue = String(format: "%.2f", convertedValue) // 2 decimal places
        } else {
            outputValue = String(format: "%.3g", convertedValue) // 3 significant figures
        }
        print("calculateConversion \(inputValue)\(selectedInputUnit.symbol) = \(outputValue)\(selectedOutputUnit.symbol)")
    }
    
    func calculatePrice(){
        guard let input = Double(inputValue), let inputPer = Double(inputPerValue), let outputPer = Double(outputPerValue) else {
            outputValue = "0"
            return
        }

        var convertedValue: Double = 0
        convertedValue = selectedMeasurement.convert(value: input, inputPer: inputPer, outputPer: outputPer, from: selectedInputUnit, to: selectedOutputUnit)
        
        if convertedValue > 0.01 {
            outputValue = String(format: "%.2f", convertedValue) // 2 decimal places
        } else {
            outputValue = String(format: "%.3g", convertedValue) // 3 significant figures
        }
        print("calculatePrice \(inputValue)\(selectedInputUnit.symbol) = \(outputValue)\(selectedOutputUnit.symbol)")
    }
}

extension MainViewModel{
    
}
