//
//  NetworkRequest.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation

protocol NetworkRequest {
    var url: URL? { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryParameters: [String: String]? { get }
}

extension NetworkRequest {
    var method: String { "GET" }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
}
