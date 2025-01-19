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
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        if widgetFamily == .systemSmall {
            iOSMainWidgetSmall()
        }else if widgetFamily == .systemMedium {
            iOSMainWidgetMedium()
        }
    }
}

struct iOSMainWidgetSmall: View {
    var body: some View {
        VStack(spacing: 12){
            PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=length", imgName: "arrow.left.and.right", text: "Length", layout: .horizontal)
            
            PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=weight", imgName: "escape", text: "Weight", layout: .horizontal)
        }
    }
}

struct iOSMainWidgetMedium: View {
    var body: some View {
        VStack(spacing: 12){
            HStack(spacing: 8){
                PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=eggs", imgName: "cart", text: "Eggs", layout: .vertical)
                PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=length", imgName: "arrow.left.and.right", text: "Length", layout: .vertical)
                PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=weight", imgName: "escape", text: "Weight", layout: .vertical)
                PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=volume", imgName: "cube", text: "Volume", layout: .vertical)
            }
            HStack{
                PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=temperature", imgName: "thermometer.medium", text: "Temperature", layout: .vertical)
                PAIWelcomeWidgetButton(urlString: "pugskyiuc://converter?type=area", imgName: "house", text: "Area", layout: .vertical)
            }
        }
    }
}

struct PAIWelcomeWidgetButton: View {
    @Environment(\.colorScheme) var colorScheme
    let urlString: String
    let imgName: String
    let text: String
    let layout: Layout
    
    enum Layout { case vertical, horizontal}
    
    var body: some View {
        Link(destination: URL(string: urlString)!, label: {
            
            ZStack(alignment: .center){
                colorScheme == .dark ? Color(hex: "424242") : Color.white
                if layout == .vertical {
                    VStack(alignment: .center, spacing: 5){
                        Image(systemName: imgName)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        Text(text)
                            .font(.system(size: 12).weight(.bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                    .padding(10)
                }else{
                    HStack(alignment: .center, spacing: 5){
                        Image(systemName: imgName)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        Text(text)
                            .font(.system(size: 12).weight(.bold))
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                    }
                    .padding(10)
                }
                
            }
        })
        .buttonStyle(.plain)
        .cornerRadius(15)
        .frame(maxHeight: .infinity)
        
    }
}

struct iOSUnitConverterWidget: Widget {
    @Environment(\.colorScheme) var colorScheme
    let kind: String = "iOSUnitConverterWidget"
    
    var bgColor: Color {
        colorScheme == .dark ? Color(hex: "1C1C1E") : Color(hex: "F8F8F8")
    }

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            iOSUnitConverterWidgetEntryView(entry: entry)
                .containerBackground(Color(.secondarySystemBackground), for: .widget)
        }
        .supportedFamilies([
            .systemSmall, .systemMedium,
            .accessoryCircular
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

extension View {
    @ViewBuilder func widgetBackground<T: View>(@ViewBuilder content: () -> T) -> some View {
        if #available(iOS 17.0, *) {
            containerBackground(for: .widget, content: content)
        }else {
            background(content())
        }
    }
}

#Preview(as: .systemMedium) {
    iOSUnitConverterWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
