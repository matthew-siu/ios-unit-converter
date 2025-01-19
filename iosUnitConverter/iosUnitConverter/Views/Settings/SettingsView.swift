//
//  SettingsView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 19/1/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            // Main List
            List {
                Section {
                    SettingsRow(title: "Install Widget", subtitle: "Add for quick access") {
                        viewModel.installWidget()
                    }
                    
                    SettingsRow(title: "Gift us a coffee", subtitle: "Remove annoying Ads") {
                        viewModel.giftUsCoffee()
                    }
                    
                    SettingsRow(title: "Rate Us", subtitle: "Show us some love!") {
                        viewModel.rateUs()
                    }
                    
                    SettingsRow(title: "Themes", subtitle: "Customize app appearance") {
                        viewModel.customizeThemes()
                    }
                }
                
                // Restore Purchases and Terms of Service
                Section {
                    Button(action: {
                        viewModel.restorePurchases()
                    }) {
                        Text("Restore Purchases")
                            .foregroundColor(.green)
                    }
                    
                    Button(action: {
                        viewModel.viewTermsOfService()
                    }) {
                        Text("Terms of Service")
                            .foregroundColor(.green)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            // App Version
            Text("Ver \(viewModel.appVersion)")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .navigationBarTitle("Menu", displayMode: .inline)
        .navigationBarItems(trailing: Button("Done") {
            // Logic to dismiss the view
            print("Done tapped")
        })
    }
}

struct SettingsRow: View {
    var title: String
    var subtitle: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    NavigationStack{
        SettingsView()
    }
}
