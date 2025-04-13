//
//  Metra_LiveLiveActivity.swift
//  Metra Live
//
//  Created by Benjamin Shabowski on 4/12/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Metra_LiveLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MetraLiveAttributes.self) { context in
            let attributes = context.attributes
            VStack {
                HStack {
                    Text(attributes.trainNumber)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color(hex: "#\(attributes.lineColor)")))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("\(attributes.fromStation) -> \(context.attributes.toStation)")
                }
                HStack {
                    StationView(primary: false, time: DateComponents(hour: 13, minute: 23), station: "Oak Park")
                    StationView(primary: true, time: DateComponents(hour: 13, minute: 40), station: "Geneva")
                    StationView(primary: false, time: DateComponents(hour: 13, minute: 46), station: "Elburn")
                }
                Text("Estimated trip arrival time: \(formattedTime(from: attributes.arrivalTime))")
            }.scaledToFit()
                .frame(height: 160)
                .activityBackgroundTint(Color.gray)
                .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.attributes.trainNumber)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.attributes.trainNumber)")
            } minimal: {
                Text(context.attributes.trainNumber)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}

func formattedTime(from components: DateComponents) -> String {
    // Use calendar to get a Date from components
    let calendar = Calendar.current
    if let date = calendar.date(from: components) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // 3:12 PM
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter.string(from: date)
    } else {
        return "Invalid time"
    }
}

#Preview("Notification", as: .content, using: MetraLiveAttributes.init(toStation: "Geneva", fromStation: "Chicago OTC", startTime: DateComponents(), arrivalTime: DateComponents(hour:15, minute: 13), trainNumber: "510", lineColor: "")) {
   Metra_LiveLiveActivity()
} contentStates: {
    MetraLiveAttributes.ContentState(nextStop: "Elburn", currentStop: "Windfiled", currentStopLeaveTime: DateComponents(), nextStopArrivalTime: DateComponents(), finalDesitinationArrivalTime: DateComponents())
}
