//
//  MetraView.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/20/25.
//

import SwiftUI

struct MetraView: View {
    @EnvironmentObject var viewModel: MetraDataModel
    
    @State var routeSelected: String = "UP-W"
    
    var body: some View {
        Picker("Route", selection: $routeSelected) {
            ForEach(viewModel.metraTrainStops.map{$0.route}, id: \.routeId){
                Text($0.routeName).tag($0.routeId)
            }
        }
    }
}

#Preview {
    MetraView()
}
