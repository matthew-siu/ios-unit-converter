//
//  InstallWidgetTutorialView.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 8/2/2025.
//

import SwiftUI

struct InstallWidgetTutorialView: View {
    var body: some View {
        ScrollView(content: {
            VStack(alignment: .leading, spacing: 16){
                Text("**Quickly access Unit Converter with a simple widget:**")
                
                ScrollView(.horizontal){
                    HStack{
                        Image("installWidgetImg1")
                        Image("installWidgetImg2")
                    }
                }
                .padding(.trailing, -24)
                .scrollIndicators(.hidden)
                
                Text(.init("**Add widget to your iPhone:**\n\n**1. Tap and hold** an empty space on your home screen, then **tap** the edit button"))
                
                Image("installWidgetImg3")
                    .cornerRadius(13)
                
                Text("2. Find the Unit Converter widget by **scrolling or searching**")
                
                Image("installWidgetImg4")
                    .cornerRadius(13)
                
                Text("3. Choose a size, tap **Add Widget**, and place it where you want.")
                
                Image("installWidgetImg5")
                    .cornerRadius(13)
            }
            .padding(.horizontal, 24)
        })
        .navigationBarTitle("Install Widget", displayMode: .inline)
    }
}

#Preview {
    InstallWidgetTutorialView()
}
