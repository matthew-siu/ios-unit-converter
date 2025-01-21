//
//  AdmobManager.swift
//  black screen camera
//
//  Created by Matthew Siu on 24/3/2024.
//

import Foundation
import GoogleMobileAds

class AdmobManager{
    static let shared = AdmobManager()
    
    public var rewardedAd: GADRewardedAd?
    public var interstitial: GADInterstitialAd?
    
    private var bannerAdUnitID: String{
        return Constants.Admob.BANNER_ADS_UNIT_ID
    }
    private var InterstitialAdUnitID: String{
        return Constants.Admob.INTERSTITIAL_ADS_UNIT_ID
    }
    private var rewardedAdUnitID: String{
        return Constants.Admob.REWARDED_ADS_UNIT_ID
    }
    
    func initialize(){
        print("AdmobManager initialize")
        GADMobileAds.sharedInstance().start { status in
            print("GADMobileAds started")
            self.prepareRewardedAds()
            
            self.prepareInterstitialAds()
        }
    }
    
    func prepareRewardedAds(){
        print("prepareFirstRewardedAd")
        GADRewardedAd.load(
            withAdUnitID: self.rewardedAdUnitID,
            request: GADRequest()) { ad, error in
            if let error = error {
                return print("[RewardedAds] Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
            }else{
                print("[RewardedAds] Prepared")
                self.rewardedAd = ad
            }
            
        }
    }
    
    func prepareInterstitialAds(){
        GADInterstitialAd.load(
            withAdUnitID: self.InterstitialAdUnitID,
            request: GADRequest(),
            completionHandler: { [self] ad, error in
            if let error = error {
                print("[Interstitial] Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
                print("[Interstitial] Prepared")
                self.interstitial = ad
        })
    }
}

extension AdmobManager{
    func disableAdsCounter() -> Double{
        let timestamp = Date().timeIntervalSince1970 + (1 * 24 * 60 * 60) // Add 1 day
        print("disableAdsCounter free until \(DateFormatter.localizedString(from: Date(timeIntervalSince1970: timestamp), dateStyle: .medium, timeStyle: .medium))")
        LocalStorage.save(Constants.Storage.adsFreeTimestamp, timestamp)
        return timestamp
    }
    
    func skipAdsCounter() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        if let adsFreeTimestamp = LocalStorage.getDouble(Constants.Storage.adsFreeTimestamp){
            print("Ads Free Timestamp: \(DateFormatter.localizedString(from: Date(timeIntervalSince1970: adsFreeTimestamp), dateStyle: .medium, timeStyle: .medium))")
            return currentTime < adsFreeTimestamp
        }else{
            return false
        }
        
    }
}
