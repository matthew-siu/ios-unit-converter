//
//  iOSUnitConverterWidgetBundle.swift
//  iOSUnitConverterWidget
//
//  Created by Matthew Siu on 7/1/2025.
//

import WidgetKit
import SwiftUI

@main
struct iOSUnitConverterWidgetBundle: WidgetBundle {
    var body: some Widget {
        iOSUnitConverterWidget()
        if #available(iOSApplicationExtension 18.0, *) {
            iOSUnitConverterWidgetControl()
        }
    }
}
