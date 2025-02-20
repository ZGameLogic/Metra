import SwiftUI

struct MetraView: View {
    @EnvironmentObject var viewModel: MetraDataModel
    
    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: "group.com.zgamelogic.metra")!
    }
    
    @State private var routeSelected: String
    @State private var fromSelected: String
    @State private var toSelected: String
    
    @State var isLoadingTimes = false
    @State var stopTimes: [MetraTrainSearchResult] = []

    var routes: [MetraRoute] {
        [MetraRoute(routeName: "None Selected", routeColor: "", routeId: "none")] + viewModel.metraTrainStops.map { $0.route }
    }
    
    var stops: [MetraStop] {
        [MetraStop(stopId: "none", stopName: "None Selected")] + viewModel.getStationsOnRoute(routeId: routeSelected)
    }
    
    init() {
        let sharedDefaults = UserDefaults(suiteName: "group.com.zgamelogic.metra")
        _routeSelected = State(initialValue: sharedDefaults?.string(forKey: "routeSelected") ?? "none")
        _fromSelected = State(initialValue: sharedDefaults?.string(forKey: "fromSelected") ?? "none")
        _toSelected = State(initialValue: sharedDefaults?.string(forKey: "toSelected") ?? "none")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Controlls") {
                    Picker("Route", selection: $routeSelected) {
                        ForEach(routes, id: \.routeId){
                            Text($0.routeName).tag($0.routeId)
                        }
                    }
                    Picker("From Station", selection: $fromSelected){
                        ForEach(stops, id: \.stopId) {
                            Text($0.stopName).tag($0.stopId)
                        }
                    }.disabled(routeSelected == "none")
                    Picker("To Station", selection: $toSelected){
                        ForEach(stops, id: \.stopId) {
                            Text($0.stopName).tag($0.stopId)
                        }
                    }.disabled(routeSelected == "none")
                }
                if(!stopTimes.isEmpty){
                    Section("Times"){
                        ForEach(stopTimes, id: \.trainNumber){
                            TrainSearchResult(result: $0, lineColor: viewModel.getRouteColor(routeId: routeSelected))
                        }
                    }
                }
            }.navigationTitle("Metra")
        }.onChange(of: routeSelected) { oldValue, newValue in
            sharedDefaults.set(newValue, forKey: "routeSelected")
            fromSelected = "none"
            toSelected = "none"
            stopTimes = []
        }.onChange(of: fromSelected) { oldValue, newValue in
            sharedDefaults.set(newValue, forKey: "fromSelected")
        }.onChange(of: toSelected) { oldValue, newValue in
            sharedDefaults.set(newValue, forKey: "toSelected")
        }.onChange(of: [fromSelected, toSelected]) { oldValue, newValue in
            if (fromSelected == "none" || toSelected == "none") { return }
            search()
        }.onAppear {
            if(fromSelected == "none" || toSelected == "none" || routeSelected == "none") { return }
            search()
        }.refreshable {
            search()
        }
    }
    
    func search(){
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
