//
//  LocationManager.swift
//  Metra
//
//  Created by Benjamin Shabowski on 3/1/25.
//

import CoreLocation
import WidgetKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationDenied = false
    let chicagoRegion = CLCircularRegion(
        center: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298),
        radius: 16093.4,
        identifier: "ChicagoArea"
    )

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        chicagoRegion.notifyOnEntry = true
        chicagoRegion.notifyOnExit = true
    }

    func requestPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func startGeofencing() {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationManager.startMonitoring(for: chicagoRegion)
            print("Started monitoring Chicago geofence.")
        } else {
            print("Geofencing not supported on this device.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedAlways {
            startGeofencing()
        } else if status == .denied || status == .restricted {
            locationDenied = true
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region.identifier == "ChicagoArea" {
            DispatchQueue.main.async {
                self.swapStations()
                print("Entered Chicago region, set 'from' to OTC.")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == "ChicagoArea" {
            DispatchQueue.main.async {
                self.swapStations()
                print("Exited Chicago region")
            }
        }
    }
    
    func swapStations(){
        let oldFrom = UserDefaults.standard.value(forKey: "fromSelected")
        let oldTo = UserDefaults.standard.value(forKey: "toSelected")
        if let oldFrom = oldFrom as? String, let oldTo = oldTo as? String {
            if(oldFrom.contains("OTC") || oldTo.contains("OTC")){
                print("Swapping stations")
                UserDefaults.standard.setValue(oldTo, forKey: "fromSelected")
                UserDefaults.standard.setValue(oldFrom, forKey: "toSelected")
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
