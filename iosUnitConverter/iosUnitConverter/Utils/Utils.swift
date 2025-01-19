//
//  Utils.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 19/1/2025.
//

import Foundation

class Utils{
    static func getVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return "0.0.0"}
        return appVersion
    }
    
    static func getBuildNumber() -> String{
        guard let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return "0"}
        return buildNumber
    }
}
