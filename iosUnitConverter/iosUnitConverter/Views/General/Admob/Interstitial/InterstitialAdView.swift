//
//  InterstitialAdView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 21/1/2025.
//

import SwiftUI
import GoogleMobileAds

struct InterstitialAdView: UIViewControllerRepresentable {
    var onAdDismissed: (() -> Void)?

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = InterstitialAdViewController()
        viewController.onAdDismissed = onAdDismissed
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

class InterstitialAdViewController: UIViewController, GADFullScreenContentDelegate {
    var onAdDismissed: (() -> Void)?
    private var interstitialAd: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interstitialAd = AdmobManager.shared.interstitial
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("InterstitialAdViewController show")
        self.show()
    }

    func show() {
        if let ad = interstitialAd {
            ad.fullScreenContentDelegate = self
            ad.present(fromRootViewController: self)
        } else {
            print("[Interstitial] Ad wasn't ready")
            AdmobManager.shared.prepareInterstitialAds()
            onAdDismissed?()
        }
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[Interstitial] Ad failed to present full screen content: \(error.localizedDescription)")
        AdmobManager.shared.prepareInterstitialAds()
        onAdDismissed?()
    }

    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[Interstitial] Ad will dismiss full screen content.")
        AdmobManager.shared.prepareInterstitialAds()
        NotificationCenter.default.post(name: Constants.Noti.InterstitialAdsFinsihedNotification, object: nil)
        onAdDismissed?()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[Interstitial] Ad did dismiss full screen content.")
        onAdDismissed?()
    }
}
