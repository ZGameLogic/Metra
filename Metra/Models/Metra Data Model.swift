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
    
    init() {
        self.metraTrainStops = []
        metraTrainStopsLoading = true
        refresh()
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
                case .failure(let error):
                    print(error)
                }
                self.metraTrainStopsLoading = false
            }
        }
    }
}
