//
//  NetworkService.swift
//  MarvelliciousVIP
//
//  Created by Mert Gürcan on 4.01.2024.
//

import Foundation

/// Custom Error enum for handle different types of errors
public enum CustomError: Error {
    case parseError
    case serverError(_ error: Error)
    case responseNil
}

/// Service protocol that blueprint of our service class
public protocol ServiceProtocol {

    /// Aysnc network call handler
    ///  - Parameter resource: Owns essential parameters for network calls
    ///  - Returns: Result of our network call
    func load<T>(resource: Resource<T>, completion: @escaping(URLNetworkResponse<T?>) -> ())
}

/// Service class that created with service protocol
open class Service : ServiceProtocol {

    open func load<T>(resource: Resource<T>, completion: @escaping(URLNetworkResponse<T?>) -> ()) {

        var urls = URLComponents(string: resource.url)

        urls?.queryItems = [
            URLQueryItem(name: "apikey", value: "67f422988e7b48b55fe0070f752ec338" ),URLQueryItem(name: "hash", value: "30cfe10275d6b39bb2e998259e9334be"), URLQueryItem(name: "ts", value: "1")
        ]

        if !(resource.param?.isEmpty ?? true) {
            if let params = resource.param {
                for (key, value) in params {
                    urls?.queryItems?.append(URLQueryItem(name: key, value: value as? String))
                }
            }
        }

        URLSession.shared.dataTask(with: URLRequest(url: (urls?.url)!)){ data,response,error in
            if let data = data {
                do{
//                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
//                        print(jsonResult)
//                    }
                    let decoder = JSONDecoder()
                    let device = try decoder.decode(T.self, from: data)
                    completion(.succes(device))
                } catch let err {
                    print(err)
                    completion(.failure(CustomError.parseError))
                }
            }
        }.resume()
    }

    public init() {
    }
}
