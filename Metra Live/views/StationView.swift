//
//  StationView.swift
//  Metra LiveExtension
//
//  Created by Benjamin Shabowski on 4/12/25.
//

import SwiftUI

struct StationView: View {
    let primary: Bool
    let time: DateComponents
    let station: String
    
    var body: some View {
        VStack {
            Text(station)
                .font(.system(size: 10))
            Text(formattedTime(from: time))
                .font(.system(size: 10))
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
        .background(Rectangle().fill(Color.red))
        .cornerRadius(4)
        .foregroundColor(.white)
        .lineLimit(1)
        .frame(width: 60, height: 60)
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
}
