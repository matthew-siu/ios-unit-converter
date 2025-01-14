//
//  iOSUnitConverterWidget.swift
//  iOSUnitConverterWidget
//
//  Created by Matthew Siu on 7/1/2025.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct iOSUnitConverterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=length", imgName: "gearshape", text: "Settings")
            
            PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=weight", imgName: "keyboard", text: "Keyboard")
        }
    }
}

struct PAIWelcomeWidgetButton: View {
    let urlString: String
    let imgName: String
    let text: String
    
    var body: some View {
        Link(destination: URL(string: urlString)!, label: {
            
            ZStack(alignment: .leading){
                Color.black.opacity(0.4)
                VStack(alignment: .leading, spacing: 0){
                    Image(systemName: imgName)
                        .foregroundStyle(.white)
                    Text(text)
                        .font(.system(size: 14).weight(.regular))
                        .foregroundStyle(.white)
                }
                .padding(10)
            }
        })
        .buttonStyle(.plain)
        .background(Color("p200").opacity(0.6))
        .cornerRadius(15)
        .frame(maxHeight: .infinity)
        
    }
}

struct iOSUnitConverterWidget: Widget {
    let kind: String = "iOSUnitConverterWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            iOSUnitConverterWidgetEntryView(entry: entry)
                .containerBackground(.gray, for: .widget)
        }
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge,
            .accessoryCircular, .accessoryRectangular, .accessoryInline
        ])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    iOSUnitConverterWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
