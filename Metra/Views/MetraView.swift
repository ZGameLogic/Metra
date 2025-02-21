import SwiftUI
import WidgetKit

struct MetraView: View {
    @EnvironmentObject var viewModel: MetraDataModel

    @AppStorage("routeSelected", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var routeSelected: String = "none"
    @AppStorage("fromSelected", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var fromSelected: String = "none"
    @AppStorage("toSelected", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var toSelected: String = "none"
    @AppStorage("lineColor", store: UserDefaults(suiteName: "group.com.zgamelogic.metra")) private var lineColor: String = "none"

    @State var isLoadingTimes = false
    @State var stopTimes: [MetraTrainSearchResult] = []

    var routes: [MetraRoute] {
        [MetraRoute(routeName: "None Selected", routeColor: "", routeId: "none")] + viewModel.metraTrainStops.map { $0.route }
    }

    var stops: [MetraStop] {
        [MetraStop(stopId: "none", stopName: "None Selected")] + viewModel.getStationsOnRoute(routeId: routeSelected)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Controls") {
                    Picker("Route", selection: $routeSelected) {
                        ForEach(routes, id: \.routeId) {
                            Text($0.routeName).tag($0.routeId)
                        }
                    }
                    Picker("From Station", selection: $fromSelected) {
                        ForEach(stops, id: \.stopId) {
                            Text($0.stopName).tag($0.stopId)
                        }
                    }.disabled(routeSelected == "none")
                    Picker("To Station", selection: $toSelected) {
                        ForEach(stops, id: \.stopId) {
                            Text($0.stopName).tag($0.stopId)
                        }
                    }.disabled(routeSelected == "none")
                    HStack {
                        Spacer()
                        Button("Switch") {
                            let old = toSelected
                            toSelected = fromSelected
                            fromSelected = old
                        }.disabled(routeSelected == "none" || toSelected == "none" || fromSelected == "none")
                        Spacer()
                    }
                }
                if (!stopTimes.isEmpty) {
                    Section("Times") {
                        ForEach(stopTimes, id: \.trainNumber) {
                            TrainSearchResult(result: $0, lineColor: viewModel.getRouteColor(routeId: routeSelected))
                        }
                    }
                }
            }.navigationTitle("Metra")
        }.onChange(of: routeSelected) { _, newValue in
            fromSelected = "none"
            toSelected = "none"
            stopTimes = []
        }.onChange(of: [fromSelected, toSelected]) { _, _ in
            if fromSelected != "none" && toSelected != "none" {
                WidgetCenter.shared.reloadAllTimelines()
                search()
            }
        }.onAppear {
            if fromSelected != "none" && toSelected != "none" && routeSelected != "none" {
                search()
            }
        }.refreshable {
            if fromSelected != "none" && toSelected != "none" && routeSelected != "none" {
                search()
            }
        }
    }

    func search() {
        lineColor = viewModel.getRouteColor(routeId: routeSelected)
        isLoadingTimes = true
        WraithService.searchForStopTimes(route: routeSelected, to: toSelected, from: fromSelected) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.stopTimes = data
                case .failure(let error):
                    print(error)
                }
                self.isLoadingTimes = false
            }
        }
    }
}
