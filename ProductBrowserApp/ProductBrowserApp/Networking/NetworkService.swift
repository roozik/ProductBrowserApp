//
//  NetworkService.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Combine
import Foundation

class NetworkService {
    func performRequest<T: Decodable>(_ request: NetworkRequest) -> AnyPublisher<T, NetworkError> {
        guard var url = request.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        if let queryParameters = request.queryParameters {
            url = addQueryParameters(to: url, parameters: queryParameters) ?? url
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { NetworkError.requestFailed($0) }
            .flatMap { output -> AnyPublisher<T, NetworkError> in
                guard let response = output.response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                    return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
                }

                return Just(output.data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { NetworkError.decodingError($0) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    private func addQueryParameters(to url: URL, parameters: [String: String]) -> URL? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = urlComponents?.queryItems ?? []

        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}
