//
//  Metra Data Model.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/20/25.
//

import Foundation

class MetraDataModel: ObservableObject {
    @Published var metraTrainStops: [MetraRouteWithStops]
    @Published var metraTrainStopsLoading: Bool
    
    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: "group.com.zgamelogic.metra")!
    }
    
    init() {
        let thing = UserDefaults(suiteName: "group.com.zgamelogic.metra")!
        if let savedData = thing.data(forKey: "routes") {
            do {
                let decoder = JSONDecoder()
                metraTrainStops = try decoder.decode([MetraRouteWithStops].self, from: savedData)
            } catch {
                print("Failed to decode route with stops: \(error)")
                metraTrainStops = []
            }
        } else {
            metraTrainStops = []
        }
        metraTrainStopsLoading = true
        refresh()
    }
    
    func getStationsOnRoute(routeId: String) -> [MetraStop] {
        return metraTrainStops.filter{$0.route.routeId == routeId}.first?.stops ?? []
    }
    
    func getRouteColor(routeId: String) -> String {
        metraTrainStops.filter{$0.route.routeId == routeId}.first?.route.routeColor ?? "000000"
    }
    
    func refresh(){
        getMetraRoutesWithStops()
    }
    
    func getMetraRoutesWithStops(){
        WraithService.getRoutesWithStops { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.metraTrainStops = data
                    do {
                        let encoder = JSONEncoder()
                        let e = try encoder.encode(data)
                        self.sharedDefaults.set(e, forKey: "routes")
                    } catch {
                        print("Failed to encode route with stops: \(error)")
                    }
                case .failure(let error):
                    print(error)
                }
                self.metraTrainStopsLoading = false
            }
        }
    }
}
