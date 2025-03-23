//
//  Train Search Result.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/20/25.
//

import SwiftUI

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

#Preview {
    TrainSearchResult(result: MetraTrainSearchResult(depart: DateComponents(hour: 14, minute: 30), arrive: DateComponents(hour: 15, minute: 30), trainNumber: "32"), lineColor: "000000")
}
