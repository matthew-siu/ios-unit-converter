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
    
    @StateObject private var vm = MainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
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
                            VStack(spacing: 12) {
                                HStack(spacing: vm.isEggsSelected ? 5 : 10) {
                                    if vm.isEggsSelected{
                                        Text("$")
                                    }
                                    TextField("Enter Price", text: $vm.inputValue)
                                        .padding(.horizontal, 13)
                                        .keyboardType(.decimalPad)
                                        .disabled(true)
                                        .frame(height: 50)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(10)
                                        .onChange(of: vm.inputValue) { oldValue, newValue in
                                            // Restrict to numbers and decimal point
                                            vm.inputValue = newValue.filter { $0.isNumber || $0 == "." }
                                            // Prevent multiple decimals
                                            if vm.inputValue.components(separatedBy: ".").count > 2 {
                                                vm.inputValue = String(vm.inputValue.dropLast())
                                            }
                                            self.vm.calculateConversion()
                                        }
                                    
                                    if vm.isEggsSelected{
                                        Text("per")
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
                                
                                HStack(spacing: vm.isEggsSelected ? 5 : 10) {
                                    if vm.isEggsSelected{
                                        Text("$")
                                    }
                                    TextField("", text: $vm.outputValue)
                                        .padding(.horizontal, 13)
                                        .keyboardType(.decimalPad)
                                        .disabled(true)
                                        .frame(height: 50)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(10)
                                    
                                    if vm.isEggsSelected{
                                        Text("per")
                                    }
                                    
                                    Menu{
                                        Picker(selection: $vm.selectedOutputUnit) {
                                            ForEach(vm.selectedMeasurement.units, id: \.symbol) { unit in
                                                Text(unit.symbol)
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
                                }
                                
                            }
                            
                            Button {
                                self.vm.swapInputAndOutputUnit()
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(5)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                            }
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
                
                Spacer()
                
                CustomKeyboardView(text: $vm.inputValue) {
                    
                }
            }
            .navigationTitle("Unit Converter") // Title added here
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.secondarySystemBackground).ignoresSafeArea())
            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    EditButton()
                //                }
                ToolbarItem {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .tint(colorScheme == .dark ? Color.white : Color.black)
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
            .background(isSelected ? Color.yellow : Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .orange : Color(hex: "ECECEC"), lineWidth: 2)
            )
            .cornerRadius(8)
            
        }
    }
}

extension ContentView {
    
    private func selectMeasurement(new: MeasurementType) {
//        self.vm.selectMeasurement(new: new)
        withAnimation {
            vm.selectedMeasurement = new
            vm.selectedInputUnit = new.units[0]
            vm.selectedOutputUnit = new.units[1]
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
        ContentView()
            .environment(\.colorScheme, .light)
        
//        ContentView()
//            .environment(\.colorScheme, .dark)
    }
    //    ContentView()
    //        .modelContainer(for: Item.self, inMemory: true)
}
