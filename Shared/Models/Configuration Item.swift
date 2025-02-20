//
//  Configuration Item.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import Foundation
import SwiftData

@Model
final class ConfigItem {
    var key: String
    var value: String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
