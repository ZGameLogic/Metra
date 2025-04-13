//
//  Shared Data.swift
//  Metra
//
//  Created by Benjamin Shabowski on 4/12/25.
//

import Foundation
import ActivityKit

struct MetraLiveAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var nextStop: String
        var currentStop: String
        var currentStopLeaveTime: DateComponents
        var nextStopArrivalTime: DateComponents
        var delay: String?
        var finalDesitinationArrivalTime: DateComponents
    }

    var toStation: String
    var fromStation: String
    var startTime: DateComponents
    var arrivalTime: DateComponents
    var trainNumber: String
    var lineColor: String
}
