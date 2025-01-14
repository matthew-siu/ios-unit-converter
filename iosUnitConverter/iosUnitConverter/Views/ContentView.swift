//
//  ContentView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 7/1/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var measureRequest: String!
    
    let measurementTypes: [any MeasurementType] = [
        Length(),
        Weight(),
        Volume(),
        Temperature(),
        Area(),
        CookingMeasurement()
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(measurementTypes, id: \.id) { measurement in
                            NavigationLink(destination: UnitConverterView(measurement: measurement)) {
                                UnitRow(item: measurement)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Select a unit") // Title added here
            .background(Color(hex: "EFFAFF").ignoresSafeArea())
            .toolbar {
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    EditButton()
                //                }
                ToolbarItem {
                    Button(action: {
                        
                    }) {
                        Label("Add Item", systemImage: "gearshape")
                    }
                }
            }
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
            .navigationDestination(item: $measureRequest) { item in
                UnitConverterView(type: item)
            }
        }
    }
    
    struct UnitRow: View {
        let item: any MeasurementType
        
        var body: some View {
            HStack(spacing: 10) {
                Image(item.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.white)
                    .background(.white)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    let symbols = item.units.map{$0.symbol}
                    Text(symbols.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(hex: "FFFFFF"))
            .cornerRadius(12)
        }
    }
}

extension ContentView {
    private func handleIncomingURL(_ url: URL) {
        // e.g. pugskyiuc://converter?title=helloworld
        print("handleIncomingURL: \(url.absoluteString)")
        guard url.scheme == "pugskyiuc" else { return }
        if url.host == "converter", let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let title = components.queryItems?.first(where: { $0.name == "type" })?.value ?? ""
            print("go to child \(title)")
            if let _ = measurementTypes.first(where: { $0.name.lowercased() == title }) {
                measureRequest = title
                
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
