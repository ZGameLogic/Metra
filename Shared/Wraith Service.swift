//
//  Wraith Service.swift
//  Metra
//
//  Created by Benjamin Shabowski on 2/18/25.
//

import Foundation

struct WraithService {
    #if targetEnvironment(simulator)
    static let BASE_URL = "http://localhost:2004/train"
    #else
    static let BASE_URL = "https://wraith.zgamelogic.com/train"
//    static let BASE_URL = "http://192.168.1.100:2004/train"
    #endif
    
    public static func registerLiveActivity(token: String, trainNumer: String, completion: @escaping (Result<String, Error>) -> Void) {
        createData(from: "\(BASE_URL)/register/live/\(trainNumer)/\(token)", data: "", completion)
    }
    
    public static func registrationEndpoint(deviceId: String, completion: @escaping (Result<String, Error>) -> Void) {
        createData(from: "\(BASE_URL)/register/\(deviceId)", data: "", completion)
    }
    
    public static func getRoutesWithStops(completion: @escaping (Result<[MetraRouteWithStops], Error>) -> Void) {
        getData(from: "/routes", completion)
    }
    
    public static func searchForStopTimes(route: String, to: String, from: String, completion: @escaping(Result<[MetraTrainSearchResult], Error>) -> Void) {
        let query = [
            URLQueryItem(name: "route", value: route),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "from", value: from)
        ]
        getData(from: "/search", query: query, completion)
    }
    
    public static func searchForStopTimesSync(route: String, to: String, from: String) -> Result<[MetraTrainSearchResult], Error> {
        let query = [
            URLQueryItem(name: "route", value: route),
            URLQueryItem(name: "to", value: to),
            URLQueryItem(name: "from", value: from)
        ]
        return getDataSynchronously(from: "/search", query: query)
    }
    
    private static func getData<T: Decodable>(
        from path: String,
        query: [URLQueryItem]? = nil,
        _ completion: @escaping (Result<T, Error>) -> Void
    ) {
        var urlComponents = URLComponents(string: "\(BASE_URL)\(path)")!
        urlComponents.queryItems = query
        
        guard let url = urlComponents.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private static func getDataSynchronously<T: Decodable>(from urlString: String, query: [URLQueryItem]? = nil) -> Result<T, Error> {
        let semaphore = DispatchSemaphore(value: 0)
        var result: Result<T, Error>!
        
        getData(from: urlString, query: query) { asyncResult in
            result = asyncResult
            semaphore.signal()
        }
        
        semaphore.wait()
        return result
    }
    
    private static func createData<T: Encodable, D: Decodable>(
        from urlString: String,
        data dataObject: T,
        _ completion: @escaping (Result<D, Error>) -> Void
    ) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(dataObject)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(D.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
