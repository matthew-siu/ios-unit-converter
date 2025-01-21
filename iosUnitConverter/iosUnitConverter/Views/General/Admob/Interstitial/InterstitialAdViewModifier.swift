//
//  InterstitialAdViewModifier.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 21/1/2025.
//

import SwiftUI

struct InterstitialAdViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    var onAdDismissed: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            // Original content
            content

            // Overlay to show the interstitial ad
            if isShowing {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                InterstitialAdView {
                    isShowing = false
                    onAdDismissed?()
                }
                .frame(width: 0, height: 0) // Ad is full screen, so no need to occupy space
            }
        }
    }
}

extension View {
    func interstitialAd(
        isShowing: Binding<Bool>,
        onAdDismissed: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            InterstitialAdViewModifier(
                isShowing: isShowing,
                onAdDismissed: onAdDismissed
            )
        )
    }
}
