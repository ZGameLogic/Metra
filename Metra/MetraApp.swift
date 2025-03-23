//
//  MetraApp.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import SwiftUI

@main
struct MetraApp: App {
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: locationManager.startGeofencing)
        }
    }
}
