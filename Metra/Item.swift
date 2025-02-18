//
//  Item.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
