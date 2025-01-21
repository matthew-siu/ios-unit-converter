//
//  VersionControlModifier.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 21/1/2025.
//

import SwiftUI

struct VersionControlModifier: ViewModifier {
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showCancelButton: Bool = false
    let repo: RCVersionUpdateRepo?
//    let appStoreURL: URL =
    
    init(){
        self.repo = RC.shared.getVersionUpdate()
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                checkVersion()
            }
            .alert(isPresented: $showAlert) {
                if showCancelButton {
                    return Alert(
                        title: Text("Upgrade Available"),
                        message: Text(alertMessage),
                        primaryButton: .cancel(),
                        secondaryButton: .default(Text("Go to App Store"), action: {
                            if let url = repo?.url{
                                UIApplication.shared.open(url)
                            }
                        })
                    )
                } else {
                    return Alert(
                        title: Text("Upgrade Required"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Go to App Store"), action: {
                            if let url = repo?.url{
                                UIApplication.shared.open(url)
                            }
                        })
                    )
                }
            }
    }

    private func checkVersion() {
        let currentVersion = Utils.getVersion()
        guard let repo = repo else{return}
        print("checkVersion: min=\(repo.minimumSupportVersion) current=\(currentVersion) latest=\(repo.latestVersion)")
        if Utils.isHigherVersion(v1: repo.minimumSupportVersion, v2: currentVersion) {
            print("checkVersion: Force Upgrade")
            // App version < minimumSupportVersion
            alertMessage = "We no longer support this version. Please upgrade now."
            showCancelButton = false
            showAlert = true
        }
//        else if Utils.isHigherVersion(v1: repo.latestVersion, v2: currentVersion) {
//            print("checkVersion: Suggest Upgrade")
//            // App version < latestVersion
//            alertMessage = "New version has launched. Upgrade now!"
//            showCancelButton = true
//            showAlert = true
//        } else{
//            print("checkVersion: Pass")
//        }
    }
}
