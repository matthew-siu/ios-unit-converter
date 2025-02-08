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
    @Published var inputPerValue: String = ""
    @Published var outputValue: String = "0"
    @Published var outputPerValue: String = ""
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
    
    // Storage keys
    private let kLastMeasurementType = "lastMeasurementType"
    private let kPriceMode = "priceMode"
    
    private func makeUnitKey(type: String, isInput: Bool) -> String {
        return "\(type)_\(isInput ? "input" : "output")"
    }
    
    init() {
        selectedMeasurement = measurementTypes.first!
        selectedInputUnit = measurementTypes.first!.defaultInput
        selectedOutputUnit = measurementTypes.first!.defaultOutput
        
        // Load saved settings
        loadSavedSettings()
    }
    
    private func loadSavedSettings() {
        // Load last measurement type
        if let lastType = LocalStorage.getString(kLastMeasurementType),
           let savedType = measurementTypes.first(where: { $0.name == lastType }) {
            print("loadSavedSettings: load \(savedType.name)")
            selectedMeasurement = savedType
            
            // Load saved units for this type
            if let inputSymbol = LocalStorage.getString(makeUnitKey(type: lastType, isInput: true)),
               let savedInputUnit = savedType.units.first(where: { $0.symbol == inputSymbol }) {
                print("loadSavedSettings: load \(savedInputUnit.symbol)")
                selectedInputUnit = savedInputUnit
            } else {
                selectedInputUnit = savedType.defaultInput
            }
            
            if let outputSymbol = LocalStorage.getString(makeUnitKey(type: lastType, isInput: false)),
               let savedOutputUnit = savedType.units.first(where: { $0.symbol == outputSymbol }) {
                print("loadSavedSettings: load \(savedOutputUnit.symbol)")
                selectedOutputUnit = savedOutputUnit
            } else {
                selectedOutputUnit = savedType.defaultOutput
            }
        }else{
            print("loadSavedSettings: use default")
            let defaultType = measurementTypes.first(where: {$0 is Weight})!
            self.selectMeasurement(new: defaultType)
        }
        
        // Load price mode
        priceMode = LocalStorage.getBool(kPriceMode)
    }
    
    func selectMeasurement(new: MeasurementType) {
        selectedMeasurement = new
        
        // Load saved units for this type if they exist
        if let inputSymbol = LocalStorage.getString(makeUnitKey(type: new.name, isInput: true)),
           let savedInputUnit = new.units.first(where: { $0.symbol == inputSymbol }) {
            selectedInputUnit = savedInputUnit
        } else {
            selectedInputUnit = new.defaultInput
        }
        
        if let outputSymbol = LocalStorage.getString(makeUnitKey(type: new.name, isInput: false)),
           let savedOutputUnit = new.units.first(where: { $0.symbol == outputSymbol }) {
            selectedOutputUnit = savedOutputUnit
        } else {
            selectedOutputUnit = new.defaultOutput
        }
        
        // Save the selected measurement type
        LocalStorage.save(kLastMeasurementType, new.name)
        
        inputPerValue = ""
        outputPerValue = ""
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
    
    func togglePriceMode(_ enabled: Bool? = nil) {
        if let enabled = enabled {
            self.priceMode = enabled
        } else {
            self.priceMode.toggle()
        }
        // Save price mode state
        LocalStorage.save(kPriceMode, self.priceMode)
        calculateConversion()
    }
    
    func resetInputs(){
        self.inputValue = ""
        self.inputPerValue = ""
        self.outputPerValue = ""
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
        let tmpInputPer = Double(inputPerValue)
        let tmpOutputPer = Double(outputPerValue)
        
        let inputPer = tmpInputPer == 0 ? 1 : tmpInputPer ?? 1
        let outputPer = tmpOutputPer == 0 ? 1 : tmpOutputPer ?? 1
        
        guard let input = Double(inputValue) else {
            outputValue = "0"
            return
        }

        var convertedValue: Double = 0
        convertedValue = selectedMeasurement.convert(value: input, inputPer: inputPer, outputPer: outputPer, from: selectedInputUnit, to: selectedOutputUnit)
        
        if convertedValue > 1 {
            outputValue = String(format: "%.2f", convertedValue) // 2 decimal places
        } else {
            outputValue = String(format: "%.3g", convertedValue) // 3 significant figures
        }
        print("calculatePrice \(inputValue)\(selectedInputUnit.symbol) = \(outputValue)\(selectedOutputUnit.symbol)")
    }
    
    // Add unit change handler
    func unitChanged() {
        // Save current units
        LocalStorage.save(
            makeUnitKey(type: selectedMeasurement.name, isInput: true),
            selectedInputUnit.symbol
        )
        LocalStorage.save(
            makeUnitKey(type: selectedMeasurement.name, isInput: false),
            selectedOutputUnit.symbol
        )
        print("saved \(selectedMeasurement.name) \(selectedInputUnit.symbol) \(selectedOutputUnit.symbol)")
//        calculateConversion()
    }
}

extension MainViewModel{
    
}
