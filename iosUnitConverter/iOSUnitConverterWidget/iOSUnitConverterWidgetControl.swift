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
                    Label("Launch App", systemImage: "pencil.and.ruler")
                }
            }
            .displayName("Launch App")
            .description("A an example control that launches the parent app.")
        
//        StaticControlConfiguration(kind: kind){
//            Link(destination: URL(string: urlString)!, label: {
//                
//                ZStack(alignment: .leading){
//                    Color.clear
//                    VStack(alignment: .leading, spacing: 0){
//                        Image(systemName: imgName)
//                            .foregroundStyle(.white)
//                        Text(text)
//                            .font(.system(size: 14).weight(.regular))
//                            .foregroundStyle(.white)
//                    }
//                    .padding(10)
//                }
//            })
//            .buttonStyle(.plain)
//            .background(Color("p200").opacity(0.6))
//            .cornerRadius(15)
//            .frame(maxHeight: .infinity)
//        }
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

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}

struct LaunchAppIntent: OpenIntent {
    static var title: LocalizedStringResource = "Launch App"
    @Parameter(title: "Target")
    var target: LaunchAppEnum
}

enum LaunchAppEnum: String, AppEnum {
    case timer
    case history


    static var typeDisplayRepresentation = TypeDisplayRepresentation("Productivity Timer's app screens")
    static var caseDisplayRepresentations = [
        LaunchAppEnum.timer : DisplayRepresentation("Timer"),
        LaunchAppEnum.history : DisplayRepresentation("History")
    ]
}
