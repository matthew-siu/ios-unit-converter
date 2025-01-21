//
//  RewardAdView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 20/1/2025.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct RewardAdsView: UIViewControllerRepresentable {
    var onRewardReceived: (() -> Void)?

    func makeUIViewController(context: Context) -> some UIViewController {
        let view = RewardAdsViewController()
        view.onRewardReceived = onRewardReceived
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class RewardAdsViewController: UIViewController, GADFullScreenContentDelegate{
    
    var onRewardReceived: (() -> Void)?
    
    private var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.rewardedAd = AdmobManager.shared.rewardedAd
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("RewardAdsViewController show")
        self.show()
    }
    
    func show() {
        if let ad = rewardedAd {
            ad.present(fromRootViewController: self) {
                let reward = ad.adReward
                print("[RewardedAds] Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                self.onRewardReceived?()
                self.resetRewardedAds()
            }
        } else {
            print("[RewardedAds] Ad wasn't ready")
        }
    }
    
    func resetRewardedAds(){
        AdmobManager.shared.prepareRewardedAds()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[RewardedAds] Ad did fail to present full screen content.")
        self.resetRewardedAds()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[RewardedAds] Ad will present full screen content.")
        self.resetRewardedAds()
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[RewardedAds] Ad did dismiss full screen content.")
        self.resetRewardedAds()
    }
}
