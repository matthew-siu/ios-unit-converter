//
//  SettingsViewModel.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 19/1/2025.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var appVersion: String = "1.0"
    
    func installWidget() {
        // Logic to handle widget installation
        print("Install Widget tapped")
    }
    
    func giftUsCoffee() {
        // Logic to handle donations
        print("Gift us a coffee tapped")
    }
    
    func rateUs() {
        // Logic to redirect user to App Store for rating
        print("Rate Us tapped")
    }
    
    func customizeThemes() {
        // Logic to navigate to theme customization
        print("Themes tapped")
    }
    
    func restorePurchases() {
        // Logic to restore purchases
        print("Restore Purchases tapped")
    }
    
    func viewTermsOfService() {
        // Logic to open Terms of Service
        print("Terms of Service tapped")
    }
}
