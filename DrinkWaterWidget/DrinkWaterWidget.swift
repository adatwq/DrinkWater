//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Khawlah Khalid on 06/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(),currentCups: 2, totalCups: 8)

    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),currentCups: CupsInfo.shared.currentCups, totalCups: CupsInfo.shared.totalCups)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate,currentCups: CupsInfo.shared.currentCups, totalCups: CupsInfo.shared.totalCups)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let currentCups: Int
    let totalCups: Int
}

struct DrinkWaterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea().opacity(0.9)
            VStack(spacing: 16){
                HStack {
                    Group{
                        Text("\(entry.currentCups)")
                            .foregroundStyle(entry.currentCups == entry.totalCups ? Color.white : Color.orange)
                            
                        +
                        Text("/")
                        
                        +
                        Text("\(entry.totalCups)")
                    }
                    .foregroundStyle(Color.white)
                    .font(.title)
                    .bold()
                    .padding(.trailing)
                    .contentTransition(.numericText())
                    
                    Image(systemName: "drop.fill")
                        .foregroundStyle(Color.white.opacity(0.7))
                    
                        .font(.system(size: 50))
                }
                if entry.currentCups < entry.totalCups{
                        Text("Drink")
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                            .background{
                                Color.green
                            }
                            .clipShape(Capsule())
                }
            }
        }
    }
}

struct DrinkWaterWidget: Widget {
    let kind: String = "DrinkWaterWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DrinkWaterWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DrinkWaterWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    DrinkWaterWidget()
} timeline: {
    SimpleEntry(date: .now, currentCups: 3, totalCups: 8)
    SimpleEntry(date: .now, currentCups: 2, totalCups: 8)
}
