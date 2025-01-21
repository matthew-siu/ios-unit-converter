//
//  RCVersionUpdateRepo.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 21/1/2025.
//

import Foundation

class RCVersionUpdateRepo: Codable{
    // {"minimumSupportVersion":"1.0.0","latestVersion":"1.0.0","appStoreUrl":""}
    
    let minimumSupportVersion: String
    let latestVersion: String
    let appStoreUrl: String
    
    var url: URL?{
        URL(string: appStoreUrl) ?? nil
    }
}
