//
//  ContentView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 7/1/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var measureRequest: String!
    @State var selectedText: String = ""
    @State var selectedTextfield: FocusedTextfield = .inputValue
    
    enum FocusedTextfield{
        case inputValue, outputValue, inputPerValue, outputPerValue
    }
    
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                
//                BannerAdView()
//                    .frame(height: 50, alignment: .center)
                
                ScrollView {
                    VStack(spacing: 24) {
                        ScrollView(.horizontal){
                            HStack(alignment: .center, spacing: 8){
                                ForEach(vm.measurementTypes, id: \.id) { item in
                                    Button {
                                        self.selectMeasurement(new: item)
                                    } label: {
                                        TabButton(icon: item.icon, label: item.name, isSelected: item.id ==  vm.selectedMeasurement.id)
                                    }
                                    
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                        .scrollIndicators(.hidden)
                        
                        // Inputs
                        HStack(spacing: 10){
                            let spacing: CGFloat = 20
                            VStack(spacing: spacing) {
                                HStack(spacing: vm.isPriceMode ? 5 : 10) {
                                    if vm.isPriceMode{
                                        Text("$")
                                    }
                                    
                                    // input textfield
                                    TextField("Enter", text: $vm.inputValue)
                                        .padding(.horizontal, 13)
                                        .keyboardType(.decimalPad)
                                        .disabled(true)
                                        .frame(height: 50)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(10)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedTextfield == .inputValue ? Color(hex: "8A8A8A") : .clear, lineWidth: 1)
                                        }
                                        .onChange(of: vm.inputValue) { oldValue, newValue in
                                            // Restrict to numbers and decimal point
                                            vm.inputValue = newValue.filter { $0.isNumber || $0 == "." }
                                            // Prevent multiple decimals
                                            if vm.inputValue.components(separatedBy: ".").count > 2 {
                                                vm.inputValue = String(vm.inputValue.dropLast())
                                            }
                                            self.vm.calculateConversion()
                                        }
                                        .onTapGesture {
                                            print("Tap Textfield1")
                                            self.selectedTextfield = .inputValue
                                        }
                                    
                                    if vm.isPriceMode{
                                        Text("per")
                                    }
                                    
                                    // input per textfield
                                    
                                    if vm.showPerTextfield{
                                        TextField("", text: $vm.inputPerValue)
                                            .padding(.horizontal, 13)
                                            .keyboardType(.decimalPad)
                                            .disabled(true)
                                            .frame(height: 50)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(10)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedTextfield == .inputPerValue ? Color(hex: "8A8A8A") : .clear, lineWidth: 1)
                                            }
                                            .onChange(of: vm.inputPerValue) { oldValue, newValue in
                                                // Restrict to numbers and decimal point
                                                vm.inputPerValue = newValue.filter { $0.isNumber || $0 == "." }
                                                // Prevent multiple decimals
                                                if vm.inputPerValue.components(separatedBy: ".").count > 2 {
                                                    vm.inputPerValue = String(vm.inputPerValue.dropLast())
                                                }
                                                self.vm.calculatePrice()
                                            }
                                            .onTapGesture {
                                                print("Tap Textfield2")
                                                self.selectedTextfield = .inputPerValue
                                            }
                                    }
                                    
                                    Menu{
                                        Picker(selection: $vm.selectedInputUnit) {
                                            ForEach(vm.selectedMeasurement.units, id: \.symbol) { unit in
                                                Text("\(unit.symbol) (\(unit.toFullUnit()))")
                                                    .tag(unit)
                                            }
                                        } label: {}
                                    }label:{
                                        HStack {
                                            Text(vm.selectedInputUnit.symbol)
                                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        }
                                        .padding(.horizontal, 13)
                                        .frame(height: 50)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(10)
                                    }
                                    .onChange(of: vm.selectedInputUnit) { oldValue, newValue in
                                        self.vm.calculateConversion()
                                    }
                                }
                                
                                HStack(spacing: vm.isPriceMode ? 5 : 10) {
                                    if vm.isPriceMode{
                                        Text("$")
                                    }
                                    
                                    // output textfield
                                    TextField("", text: $vm.outputValue)
                                        .padding(.horizontal, 13)
                                        .keyboardType(.decimalPad)
                                        .disabled(true)
                                        .frame(height: 50)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(10)
                                    
                                    if vm.isPriceMode{
                                        Text("per")
                                    }
                                    
                                    // output per textfield
                                    if vm.showPerTextfield{
                                        TextField("", text: $vm.outputPerValue)
                                            .padding(.horizontal, 13)
                                            .keyboardType(.decimalPad)
                                            .disabled(true)
                                            .frame(height: 50)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(10)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(selectedTextfield == .outputPerValue ? Color(hex: "8A8A8A") : .clear, lineWidth: 1)
                                            }
                                            .onChange(of: vm.outputPerValue) { oldValue, newValue in
                                                // Restrict to numbers and decimal point
                                                vm.outputPerValue = newValue.filter { $0.isNumber || $0 == "." }
                                                // Prevent multiple decimals
                                                if vm.outputPerValue.components(separatedBy: ".").count > 2 {
                                                    vm.outputPerValue = String(vm.outputPerValue.dropLast())
                                                }
                                                self.vm.calculatePrice()
                                            }
                                            .onTapGesture {
                                                print("Tap Textfield4")
                                                self.selectedTextfield = .outputPerValue
                                            }
                                    }
                                    
                                    ZStack{
                                        Menu{
                                            Picker(selection: $vm.selectedOutputUnit) {
                                                ForEach(vm.selectedMeasurement.units, id: \.symbol) { unit in
                                                    Text("\(unit.symbol) (\(unit.toFullUnit()))")
                                                        .tag(unit)
                                                }
                                            } label: {}
                                        }label:{
                                            HStack {
                                                Text(vm.selectedOutputUnit.symbol)
                                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                                Spacer()
                                                Image(systemName: "chevron.down")
                                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                            }
                                            .padding(.horizontal, 13)
                                            .frame(height: 50)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(10)
                                        }
                                        .onChange(of: vm.selectedOutputUnit) { oldValue, newValue in
                                            self.vm.calculateConversion()
                                        }
                                        
                                        Button {
                                            self.vm.swapInputAndOutputUnit()
                                        } label: {
                                            Image(systemName: "arrow.up.arrow.down")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                                .padding(10)
                                                .foregroundStyle(colorScheme == .dark ? .white : .black)
                                        }
                                        .background(colorScheme == .dark ? .black : .white)
                                        .cornerRadius(.infinity)
                                        .overlay{
                                            Circle()
                                                .stroke(Color(.systemGray5), lineWidth: 1)
                                        }
                                        .padding(.bottom, 50 + spacing)
                                    }
                                    .frame(height: 50)
                                }
                                
                            }
                            
//                            Button {
//                                self.vm.swapInputAndOutputUnit()
//                            } label: {
//                                Image(systemName: "arrow.up.arrow.down")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 20, height: 20)
//                                    .padding(5)
//                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
//                            }
                        }
                        .padding(.horizontal, 12)
                        
                        Divider()
                        
                        // History Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("History")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button("Clear") {
                                    //                                history.removeAll()
                                }
                                .foregroundColor(.green)
                            }
                            
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 5)
                
                CustomKeyboardView(text: Binding(
                    get: {
                        switch selectedTextfield {
                        case .inputValue:
                            return vm.inputValue
                        case .inputPerValue:
                            return vm.inputPerValue
                        case .outputValue:
                            return vm.outputValue
                        case .outputPerValue:
                            return vm.outputPerValue
                        }
                    },
                    set: { newValue in
                        switch selectedTextfield {
                        case .inputValue:
                            vm.inputValue = newValue
                        case .inputPerValue:
                            vm.inputPerValue = newValue
                        case .outputValue:
                            vm.outputValue = newValue
                        case .outputPerValue:
                            vm.outputPerValue = newValue
                        }
                    }
                )) {
                    // Additional configuration or actions for the custom keyboard can go here
                }
                
                BannerAdView()
                    .frame(height: 50, alignment: .center)
            }
            .navigationTitle(self.vm.selectedMeasurement.name) // Title added here
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.secondarySystemBackground).ignoresSafeArea())
            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    EditButton()
                //                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "line.3.horizontal")
                    }
                    .tint(colorScheme == .dark ? Color.white : Color.black)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation{
                            if vm.isEggs{
                                self.vm.priceMode = true
                            }else{
                                self.vm.priceMode.toggle()
                            }
                        }
                    } label: {
                        Text("$ Price Mode")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? self.vm.priceMode ? .black : .white : .black)
                            .padding(5)
                            .padding(.trailing, 5)
                    }
//                    .background(self.vm.priceMode ? Color(hex: "FFDC23") : Color(.systemBackground))
                    .background(self.vm.priceMode ? Color(hex: "FFDC23") : colorScheme == .dark ? Color(.systemGray4) : .white )
                    .frame(height: 34)
                    .cornerRadius(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(self.vm.priceMode ? Color(hex: "E5B400") : Color(hex: "ECECEC"), lineWidth: colorScheme == .dark ? 0 : 1)
                    }
//                    .tint(vm.priceMode ? Color(hex: "ECECEC") : .red) // Selected is green, unselected is red
                }
            }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
        }
    }
    
    // Tab Button View
    struct TabButton: View {
        @Environment(\.colorScheme) var colorScheme
        var icon: String
        var label: String
        var isSelected: Bool = false
        
        var body: some View {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .cornerRadius(8)
                    .foregroundStyle(isSelected ? .black : colorScheme == .dark ? .white : .black)
                    
                Text(label)
                    .font(.caption)
                    .foregroundColor(isSelected ? .black : .primary)
            }
            .padding(.horizontal, 8)
            .frame(height: 70)
            .frame(minWidth: 70)
            .background(isSelected ? Color(hex: "FFDC23") : Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color(hex: "E5B400") : Color(hex: "ECECEC"), lineWidth: 2)
            )
            .cornerRadius(8)
            
        }
    }
}

extension ContentView {
    
    private func selectMeasurement(new: MeasurementType) {
//        self.vm.selectMeasurement(new: new)
        withAnimation {
            self.vm.selectMeasurement(new: new)
        }
    }
    
    private func handleIncomingURL(_ url: URL) {
        // e.g. pugskyiuc://converter?title=helloworld
        print("handleIncomingURL: \(url.absoluteString)")
        guard url.scheme == "pugskyiuc" else { return }
        self.vm.selectMeasurement(deeplink: url.absoluteString)
//        if url.host == "converter", let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
//            let title = components.queryItems?.first(where: { $0.name == "type" })?.value ?? ""
//            print("go to child \(title)")
//        }
    }
}

#Preview {
    Group {
//        ContentView()
//            .environment(\.colorScheme, .light)
        
        ContentView()
//            .environment(\.colorScheme, .dark)
    }
    //    ContentView()
    //        .modelContainer(for: Item.self, inMemory: true)
}
