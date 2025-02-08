//
//  InstallControlTutorialView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 8/2/2025.
//

import SwiftUI

struct InstallControlTutorialView: View {
    var body: some View {
        ScrollView(content: {
            VStack(alignment: .leading, spacing: 16){
                Text("**Quickly access Unit Converter with a simple control button:**")
                
                Image("installControlImg1")
                
                Text(.init("**Add Controls to your iPhone:**\n\n**1. Swipe down from the top-right corner** of the home screen to open control centre page, and **tap the + icon** in the top left corner"))
                
                Image("installControlImg2")
                    .cornerRadius(13)
                
                Text("**2. Tap the “Add a Control” button** at the bottom")
                
                Image("installControlImg3")
                    .cornerRadius(13)
                
                Text("3. Find the Unit Converter Control by **scrolling or searching**")
                
                Image("installControlImg4")
                    .cornerRadius(13)
            }
            .padding(.horizontal, 24)
        })
        .navigationBarTitle("Install Control", displayMode: .inline)
    }
}

#Preview {
    InstallControlTutorialView()
}
