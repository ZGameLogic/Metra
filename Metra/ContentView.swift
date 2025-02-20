//
//  ContentView.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configItems: [ConfigItem]

    var body: some View {
        MetraView().environmentObject(MetraDataModel())
    }

    private func addItem() {
        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ConfigItem.self, inMemory: true)
}
