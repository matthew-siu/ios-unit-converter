//
//  UnitConverterView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 8/1/2025.
//

import SwiftUI

struct UnitConverterView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: UnitConverterViewModel
    
    init(type: String){
//        self.vm = .init(type: type)
        _vm = StateObject(wrappedValue: UnitConverterViewModel(type: type))
    }
    
    init(measurement: any MeasurementType){
//        self.vm = .init(item: measurement)
        _vm = StateObject(wrappedValue: UnitConverterViewModel(item: measurement))
    }

    var body: some View {
        VStack{
            ScrollView {
                VStack(spacing: 0) {
                    // Input Section
                    VStack(spacing: 8) {
                        TextField("Enter value", text: $vm.inputValue)
                            .keyboardType(.decimalPad)
                            .onChange(of: vm.inputValue) { oldValue, newValue in
                                // Restrict to numbers and decimal point
                                vm.inputValue = newValue.filter { $0.isNumber || $0 == "." }
                                // Prevent multiple decimals
                                if vm.inputValue.components(separatedBy: ".").count > 2 {
                                    vm.inputValue = String(vm.inputValue.dropLast())
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
                                ForEach(vm.item.units, id: \.symbol) { unit in
                                    Button(action: {
                                        vm.selectedInputUnit = unit
                                        calculateConversion()
                                    }) {
                                        Text(unit.symbol)
                                            .padding(8)
                                            .frame(minWidth: 36)
                                            .background(vm.selectedInputUnit == unit ? Color.blue : Color.gray.opacity(0.2))
                                            .cornerRadius(8)
                                            .foregroundColor(vm.selectedInputUnit == unit ? .white : .blue)
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
                        Text(vm.outputValue)
                            .font(.system(size: 36))
                            .foregroundColor(.orange)
                            .bold()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                if vm.showOutputUnits{
                                    ForEach(vm.item.units, id: \.symbol) { unit in
                                        Button(action: {
                                            vm.selectedOutputUnit = unit
                                            calculateConversion()
                                        }) {
                                            Text(unit.symbol)
                                                .padding(8)
                                                .frame(minWidth: 36)
                                                .background(vm.selectedOutputUnit == unit ? Color.blue : Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                                .foregroundColor(vm.selectedOutputUnit == unit ? .white : .blue)
                                        }
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
            
            CustomKeyboardView(text: $vm.inputValue) {
                print("Press done")
            }
        }
        .navigationTitle(vm.item.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }

    private func calculateConversion() {
        guard let input = Double(vm.inputValue) else {
            vm.outputValue = "0"
            return
        }

        var convertedValue: Double = 0
        if let measurement = vm.item as? Eggs{
            let inputUnit = vm.selectedInputUnit as! UnitDozan
            convertedValue = measurement.convert(value: input, from: inputUnit, to: inputUnit)
        }else{
            let inputUnit = vm.selectedInputUnit
            let outputUnit = vm.selectedOutputUnit
            let inputMeasurement = Measurement(value: input, unit: inputUnit)
            convertedValue = inputMeasurement.converted(to: outputUnit).value
        }
        

        // Format the output: 2 decimal places for small numbers, fixed-point for others
        if convertedValue > 0.01 {
            vm.outputValue = String(format: "%.2f", convertedValue) // 2 decimal places
        } else {
            vm.outputValue = String(format: "%.3g", convertedValue) // 3 significant figures
        }
    }
}

#Preview {
    UnitConverterView(measurement: Eggs())
}
