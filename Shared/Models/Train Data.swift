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
