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
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
