//
//  Constants.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 20/1/2025.
//

struct Constants{
    let appGroupName = "group.com.nipohcuis.eclipsemints-apps"
    
    struct Admob{
        
        // Banner Ad Unit ID
        #if DEBUG
        static let BANNER_ADS_UNIT_ID = "ca-app-pub-3940256099942544/2435281174"
        #else
        static let BANNER_ADS_UNIT_ID = "ca-app-pub-8400536240691918/5282301204"
        #endif
        
        // Interstitial Ad Unit ID
        #if DEBUG
        static let INTERSTITIAL_ADS_UNIT_ID = "ca-app-pub-3940256099942544/4411468910"
        #else
        static let INTERSTITIAL_ADS_UNIT_ID = "ca-app-pub-8400536240691918/4214693748"
        #endif
        
        // Rewards Ad Unit ID
        #if DEBUG
        static let REWARDED_ADS_UNIT_ID = "ca-app-pub-3940256099942544/1712485313"
        #else
        static let REWARDED_ADS_UNIT_ID = "ca-app-pub-8400536240691918/6020667802"
        #endif
        
        
        
        static let REWARDED_DAYS: Int = 1
    }
}