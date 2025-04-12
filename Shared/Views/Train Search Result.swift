//
//  Train Search Result.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/20/25.
//

import SwiftUI
import ActivityKit

struct TrainSearchResult: View {
    let result: MetraTrainSearchResult
    let lineColor: String
    
    var body: some View {
        HStack {
            Text(result.trainNumber)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color(hex: "#\(lineColor)")))
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            VStack {
                Text(result.departString)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(result.arriveString)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            Spacer()
        }.onTapGesture {
            do {
                let adventure = MetraLiveAttributes(name: "Ben")
                let initialState = MetraLiveAttributes.ContentState(emoji: "L")
                
                print("Starting activity")
                let activity = try Activity.request(
                    attributes: adventure,
                    content: .init(state: initialState, staleDate: nil),
                    pushType: .token
                )
//                let adventure = TrainActivityAttributes(lineColorHex: lineColor)
//                let initialState = TrainActivityAttributes.ContentState(
//                    trainNumber: result.trainNumber,
//                    departureTime: Date(),
//                    arrivalTime: Date()
//                )
//                
//                print("Starting activity")
//                let activity = try Activity.request(
//                    attributes: adventure,
//                    content: .init(state: initialState, staleDate: nil),
//                    pushType: .token
//                )
//                let attributes = TrainActivityAttributes(lineColorHex: lineColor)
//                let contentState = TrainActivityAttributes.ContentState(
//                    trainNumber: result.trainNumber,
//                    departureTime: departDate,
//                    arrivalTime: arriveDate
//                )
//
//                let content = ActivityContent(state: contentState, staleDate: nil)
//                let activity = try Activity<TrainActivityAttributes>.request(
//                    attributes: attributes,
//                    content: content,
//                    pushType: nil
//                )

//                Task {
//                    for await pushToken in activity.pushTokenUpdates {
//                        let p = pushToken.reduce(""){ $0 + String(format: "%02x", $1)}
//                        WraithService.registerLiveActivity(token: p, trainNumer: result.trainNumber) { _ in }
//                        print(activity.id)
//                    }
//                }
            } catch {
                print("Error starting Live Activity: \(error)")
            }
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

struct TrainActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var trainNumber: String
        var departureTime: Date
        var arrivalTime: Date
    }

    var lineColorHex: String
}

#Preview {
    TrainSearchResult(result: MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 30), arrive: DateComponents(hour: 15, minute: 30), trainNumber: "32"), lineColor: "000000")
}
