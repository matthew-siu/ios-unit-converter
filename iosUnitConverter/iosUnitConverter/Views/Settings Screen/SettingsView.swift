//
//  SettingsView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 19/1/2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @StateObject var viewModel = SettingsViewModel()
    
    @State var showPricePopup: Bool = false
    
    var body: some View {
        VStack {
            // Main List
            List {
                Section {
                    SettingsRow(title: "Install Widget", subtitle: "Add for quick access") {
                        viewModel.installWidget()
                    }
                    
                    SettingsRow(title: "Gift us a coffee", subtitle: "Remove annoying Ads") {
//                        DispatchQueue.main.async {
//                            NotificationCenter.default.post(name: Constants.Noti.InterstitialAdsFinsihedNotification, object: nil)
//                        }
                        self.showPricePopup = true
                    }
                    
                    SettingsRow(title: "Rate Us", subtitle: "Show us some love!") {
                        self.requestReview()
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
            
            
            
            BannerAdView()
                .frame(height: 50, alignment: .center)
            
            // App Version
            Text("v\(Utils.getVersion())")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.top, 10)
        }
        .navigationBarTitle("Menu", displayMode: .inline)
        .priceScreenPopup(isPresented: $showPricePopup)
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
