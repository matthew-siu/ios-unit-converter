//
//  RewardAdViewModifier.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 21/1/2025.
//

import SwiftUI

struct RewardAdViewModifier: ViewModifier {
    @Binding var isShowing: Bool
    var onRewardReceived: (() -> Void)?

    func body(content: Content) -> some View {
        ZStack {
            // Original content
            content

            // Overlay to show the reward ad
            if isShowing {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                RewardAdsView {
                    isShowing = false
                    onRewardReceived?()
                }
                .frame(width: 0, height: 0) // Reward ad is full screen, so no need to occupy space
            }
        }
    }
}

extension View {
    func rewardAd(
        isShowing: Binding<Bool>,
        onRewardReceived: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            RewardAdViewModifier(
                isShowing: isShowing,
                onRewardReceived: onRewardReceived
            )
        )
    }
}
