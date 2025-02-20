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
    static let BASE_URL = "https://zgamelogic.com:2002/train"
    #endif
    
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
}
