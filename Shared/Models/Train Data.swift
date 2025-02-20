//
//  Train Data.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/20/25.
//

import Foundation

struct MetraRoute: Codable {
    let routeName: String
    let routeColor: String
    let routeId: String
    
    enum CodingKeys: String, CodingKey {
        case routeName = "route_long_name"
        case routeColor = "route_color"
        case routeId = "route_id"
    }
    
    init(routeName: String, routeColor: String, routeId: String) {
        self.routeName = routeName
        self.routeColor = routeColor
        self.routeId = routeId
    }
}

struct MetraStop: Codable {
    let stopId: String
    let stopName: String
    
    enum CodingKeys: String, CodingKey {
        case stopId = "stop_id"
        case stopName = "stop_name"
    }
}

struct MetraRouteWithStops: Codable {
    let route: MetraRoute
    let stops: [MetraStop]
}

struct MetraTrainSearchResult: Codable {
    let depart: DateComponents
    let arrive: DateComponents
    let trainNumber: String
    
    var departString: String {
        dateComponentsToString(depart) ?? "none"
    }
    var arriveString: String {
        dateComponentsToString(arrive) ?? "none"
    }
    
    init(depart: DateComponents, arrive: DateComponents, trainNumber: String) {
        self.depart = depart
        self.arrive = arrive
        self.trainNumber = trainNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trainNumber = try container.decode(String.self, forKey: .trainNumber)
        let departString = try container.decode(String.self, forKey: .depart)
        let arriveString = try container.decode(String.self, forKey: .arrive)
        depart = try MetraTrainSearchResult.timeToDateComponents(timeString: departString)
        arrive = try MetraTrainSearchResult.timeToDateComponents(timeString: arriveString)
    }
    
    private static func timeToDateComponents(timeString: String) throws -> DateComponents {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        guard let date = dateFormatter.date(from: timeString) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: [],
                debugDescription: "Invalid time format"
            ))
        }
        
        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: date)
    }
    
    private func dateComponentsToString(_ components: DateComponents) -> String? {
        guard let hour = components.hour, let minute = components.minute else {
            return nil
        }
        
        // Create a date using the current calendar
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date())
        
        // Use DateFormatter to format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // Convert the date to a formatted string
        return dateFormatter.string(from: date!)
    }
}
