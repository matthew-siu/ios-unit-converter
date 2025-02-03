//
//  PricePopupModifier.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 21/1/2025.
//

import Foundation
import SwiftUI

struct PricePopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    @State var showRewardAd: Bool = false

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                // Dimmed background
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        print("click!!!")
                        withAnimation {
                            self.isPresented = false
                        }
                        
                    }

                // Popup UI
                VStack(spacing: 16) {
                    // Title and Subtitle
                    VStack(spacing: 8) {
                        Text("Tired of annoying ads?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemGreen))
                        
                        Text(.init("**Gift us a coffee** and enjoy the smoothest experience!"))
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }

                    // Coffee Sizes
                    HStack(alignment: .bottom, spacing: 5) {
                        VStack{
                            CoffeeView(icon: "coffeeS", height: 86, isAds: true, priceTag: "Watch Ad"){
                                self.showRewardAd = true
                            }
                            .frame(width: 100)
                            
                            Text("No Ads Today")
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                        }
                        
                        /*
                        VStack{
                            HStack(alignment: .bottom, spacing: 5){
                                CoffeeView(icon: "coffeeM", height: 100, priceTag: "$9.99"){
                                    
                                }
                                .frame(width: 100)
                                
                                CoffeeView(icon: "coffeeL", height: 114, priceTag: "$15.99"){
                                    
                                }
                                .frame(width: 100)
                            }
                            
                            Text("Remove Ads permanently")
                                .font(.caption)
                                .foregroundColor(Color(.systemGray))
                        }
                        */
                    }

                    // Footer
                    Text("Every bit of your support helps us grow.\nThank you! 💛")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(20)
                .rewardAd(isShowing: $showRewardAd) {
                    print("[RewardedAds] Completed")
                    self.executeFreeAds()
                }
            }
        }
    }
    
    func executeFreeAds(){
        _ = AdmobManager.shared.disableAdsCounter()
        self.isPresented = false
    }
}

private struct CoffeeView: View {
    var icon: String
    var height: CGFloat
    var isAds: Bool = false
    var priceTag: String = ""
    var buttonDidPress: () -> Void

    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(height: height)
                .foregroundColor(.brown)
            
            Button(action: {
                print("Watch Ad Tapped")
                self.buttonDidPress()
            }) {
                HStack{
                    if isAds{
                        Image(systemName: "play.rectangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .foregroundColor(.black)
                    }
                    Text(priceTag)
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding(10)
                .frame(height: 40)
                .background(Color.yellow)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "E5B400"), lineWidth: 1)
                )
            }
        }
    }
}

extension View {
    func priceScreenPopup(isPresented: Binding<Bool>) -> some View {
        self.modifier(PricePopupModifier(isPresented: isPresented))
    }
}


#Preview {
    ContentView()
        .priceScreenPopup(isPresented: .constant(false))
}
