//
//  UnitConverterView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 8/1/2025.
//

import SwiftUI

struct UnitConverterView: View {
    @State var measurement: any MeasurementType
    
    @State private var inputValue: String = ""
    @State private var outputValue: String = "0"
    @State private var selectedInputUnit: Dimension
    @State private var selectedOutputUnit: Dimension
    
    let measurementTypes: [any MeasurementType] = [
        Length(),
        Weight(),
        Volume(),
        Temperature(),
        Area(),
        CookingMeasurement()
    ]

    init(type: String){
        if let matchingMeasurement = measurementTypes.first(where: { $0.name.lowercased() == type }) {
            self.measurement = matchingMeasurement
            _selectedInputUnit = State(initialValue: matchingMeasurement.units.first!)
            _selectedOutputUnit = State(initialValue: matchingMeasurement.units.first!)
        }else{
            let tmpMeasure = Length()
            self.measurement = tmpMeasure
            _selectedInputUnit = State(initialValue: tmpMeasure.units.first!)
            _selectedOutputUnit = State(initialValue: tmpMeasure.units.first!)
        }
    }
    
    init(measurement: any MeasurementType) {
        self.measurement = measurement
        _selectedInputUnit = State(initialValue: measurement.units.first!)
        _selectedOutputUnit = State(initialValue: measurement.units.first!)
    }

    var body: some View {
        VStack{
            ScrollView {
                VStack(spacing: 0) {
                    // Input Section
                    VStack(spacing: 8) {
                        TextField("Enter value", text: $inputValue)
                            .keyboardType(.decimalPad)
                            .onChange(of: inputValue) { oldValue, newValue in
                                // Restrict to numbers and decimal point
                                inputValue = newValue.filter { $0.isNumber || $0 == "." }
                                // Prevent multiple decimals
                                if inputValue.components(separatedBy: ".").count > 2 {
                                    inputValue = String(inputValue.dropLast())
                                }
                                calculateConversion()
                            }
                            .onSubmit {
                                //                            calculateConversion()
                                print("on submit")
                            }
                            .textFieldStyle(.plain)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 28))
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) {
                                    Spacer()
                                    Button("Next") {
                                        calculateConversion()
                                    }
                                }
                            }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(measurement.units, id: \.symbol) { unit in
                                    Button(action: {
                                        selectedInputUnit = unit
                                        calculateConversion()
                                    }) {
                                        Text(unit.symbol)
                                            .padding(8)
                                            .frame(minWidth: 36)
                                            .background(selectedInputUnit == unit ? Color.blue : Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                            .foregroundColor(selectedInputUnit == unit ? .white : .blue)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(16)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(20)
                    
                    // Equals Sign
                    Text("=")
                        .font(.system(size: 20))
                    
                    // Output Section
                    VStack(spacing: 8) {
                        Text(outputValue)
                            .font(.system(size: 36))
                            .foregroundColor(.orange)
                            .bold()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(measurement.units, id: \.symbol) { unit in
                                    Button(action: {
                                        selectedOutputUnit = unit
                                        calculateConversion()
                                    }) {
                                        Text(unit.symbol)
                                            .padding(8)
                                            .frame(minWidth: 36)
                                            .background(selectedOutputUnit == unit ? Color.blue : Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                            .foregroundColor(selectedOutputUnit == unit ? .white : .blue)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(16)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(20)
                }
            }
            
            Spacer()
            
            CustomKeyboardView(text: $inputValue) {
                print("Press done")
            }
        }
        .navigationTitle(measurement.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: "EFFAFF").ignoresSafeArea())
    }

    private func calculateConversion() {
        guard let input = Double(inputValue) else {
            outputValue = "0"
            return
        }
        let inputUnit = selectedInputUnit
        let outputUnit = selectedOutputUnit

        let inputMeasurement = Measurement(value: input, unit: inputUnit)
        let convertedValue = inputMeasurement.converted(to: outputUnit).value

        // Format the output: 2 decimal places for small numbers, fixed-point for others
        if convertedValue > 0.01 {
            outputValue = String(format: "%.2f", convertedValue) // 2 decimal places
        } else {
            outputValue = String(format: "%.3g", convertedValue) // 3 significant figures
        }
    }
}

#Preview {
    UnitConverterView(measurement: Length())
}
