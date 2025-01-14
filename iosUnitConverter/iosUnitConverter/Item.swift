//
//  Item.swift
//  iosUnitConverter
//
//  Created by Matthew Siu on 7/1/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
