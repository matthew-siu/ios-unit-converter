//
//  iOSUnitConverterWidgetControl.swift
//  iOSUnitConverterWidget
//
//  Created by Matthew Siu on 7/1/2025.
//

import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 18.0, *)
struct iOSUnitConverterWidgetControl: ControlWidget {
    static let kind: String = "com.nipohcuis.iosUnitConverter.iOSUnitConverterWidget"

    var body: some ControlWidgetConfiguration {
//        AppIntentControlConfiguration(
//            kind: Self.kind,
//            provider: Provider()
//        ) { value in
//            ControlWidgetToggle(
//                "Start Timer",
//                isOn: value.isRunning,
//                action: StartTimerIntent(value.name)
//            ) { isRunning in
//                Label(isRunning ? "On" : "Off", systemImage: "pencil.and.ruler")
//            }
//        }
//        .displayName("Timer")
//        .description("A an example control that runs a timer.")
        
        StaticControlConfiguration(kind: Self.kind) {
                /// This one - based on the demo code - doesn't work on simulator or device
                ControlWidgetButton(action: LaunchAppIntent()) {
                    Label("Unit Converter", systemImage: "pencil.and.ruler")
                }
            }
            .displayName("Unit Converter")
            .description("Start groceries and price match")
    }
}

@available(iOS 18.0, *)
extension iOSUnitConverterWidgetControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    struct Provider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            iOSUnitConverterWidgetControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return iOSUnitConverterWidgetControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

@available(iOS 18.0, *)
struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

@available(iOS 18.0, *)
struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Measure Type")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        
        return .result()
    }
}

@available(iOS 18.0, *)
struct LaunchAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Unit Converter"
    static var openAppWhenRun: Bool = true
    
    init() { }
    
    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        print("perform URL")
        guard let url = URL(string: "pugskyiuc://") else{
            print("Couldn't create URL")
            fatalError("Couldn't create URL")
        }
        EnvironmentValues().openURL(url)
        return .result(opensIntent: OpenURLIntent(url))
    }
}
