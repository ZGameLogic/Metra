//
//  ContentView.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        MetraView().environmentObject(MetraDataModel())
    }
}

#Preview {
    ContentView()
}
