//
//  Metra_Graphs.swift
//  Metra Graphs
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> MetraTrainTimelineEntry {
        PreviewData.data
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> MetraTrainTimelineEntry {
        PreviewData.data
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<MetraTrainTimelineEntry> {
        var entries: [MetraTrainTimelineEntry]
        let sharedDefaults = UserDefaults(suiteName: "group.com.zgamelogic.metra")
        if let route = sharedDefaults?.string(forKey: "routeSelected"),
           let to = sharedDefaults?.string(forKey: "toSelected"),
           let lineColor = sharedDefaults?.string(forKey: "lineColor"),
           let from = sharedDefaults?.string(forKey: "fromSelected") {
            let result = WraithService.searchForStopTimesSync(route: route, to: to, from: from)
            switch(result){
            case .success(let data):
                entries = [MetraTrainTimelineEntry(date: .now, results: data, lineColor: lineColor, from: from, to: to)]
            case .failure(let error):
                print(error)
                entries = [MetraTrainTimelineEntry(date: .now, results: [], lineColor: "000000", from: "", to: "")]
            }
        } else {
            print("We got here")
            entries = [MetraTrainTimelineEntry(date: .now, results: [], lineColor: "000000", from: "", to: "")]
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct MetraTrainTimelineEntry: TimelineEntry {
    let date: Date
    let results: [MetraTrainSearchResult]
    let lineColor: String
    let from: String
    let to: String
    var isValid: Bool { !results.isEmpty }
    
}

struct Metra_GraphsEntryView: View {
    @AppStorage("routeSelected", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var route: String = "none"
    @AppStorage("fromSelected", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var from: String = "none"
    @AppStorage("toSelected", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var to: String = "none"
    @AppStorage("lineColor", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var lineColor: String = "000000"

    var entry: Provider.Entry

    var body: some View {
        if entry.isValid {
            VStack {
                let limitedResults = Array(entry.results.prefix(6))
                let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
                Text("\(from) -> \(to)")
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(limitedResults, id: \.trainNumber) { trainRoute in
                        TrainSearchResult(result: trainRoute, lineColor: lineColor)
                            .frame(maxWidth: .infinity, minHeight: 50)
                    }
                }
                Spacer()
            }
        } else {
            Text("Please open the app and select your route and stations")
        }
    }
}

struct Metra_Graphs: Widget {
    let kind: String = "Metra_Graphs"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Metra_GraphsEntryView(entry: entry).containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Metra Schedule")
        .description("A schedule widget.")
        .supportedFamilies([.systemMedium])
    }
}

extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
}

#Preview(as: .systemMedium) {
    let mockDefaults = UserDefaults(suiteName: "group.com.zgamelogic.metra")!
    mockDefaults.set("MockRoute", forKey: "routeSelected")
    mockDefaults.set("Chicago OTC", forKey: "fromSelected")
    mockDefaults.set("Geneva", forKey: "toSelected")
    mockDefaults.set("FF5733", forKey: "lineColor")
    return Metra_Graphs()
} timeline: {
    PreviewData.data
}

#Preview(as: .systemMedium) {
    let mockDefaults = UserDefaults(suiteName: "PreviewSuite")!
    mockDefaults.set("none", forKey: "routeSelected")
    mockDefaults.set("none", forKey: "fromSelected")
    mockDefaults.set("none", forKey: "toSelected")
    mockDefaults.set("none", forKey: "lineColor")
    return Metra_Graphs()
} timeline: {
    MetraTrainTimelineEntry(date: .now, results: [], lineColor: "000000", from: "", to: "")
}


struct PreviewData {
    static let data: MetraTrainTimelineEntry = MetraTrainTimelineEntry(date: .now, results: [
        MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 30), arrive: DateComponents(hour: 15, minute: 15), trainNumber: "350"),
        MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 40), arrive: DateComponents(hour: 15, minute: 25), trainNumber: "37"),
        MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 50), arrive: DateComponents(hour: 15, minute: 35), trainNumber: "39"),
        MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 30), arrive: DateComponents(hour: 15, minute: 15), trainNumber: "41"),
        MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 40), arrive: DateComponents(hour: 15, minute: 25), trainNumber: "43"),
        MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 50), arrive: DateComponents(hour: 15, minute: 35), trainNumber: "45")
    ], lineColor: "000000", from: "Geneva", to: "Chicago OTC")
}
