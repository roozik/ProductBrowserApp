//
//  RequestProvider.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation

enum Endpoint: String {
    case users = "https://api.escuelajs.co/api/v1/products"
}

struct RequestProvider: NetworkRequest {
    let offset: Int
    let limit: Int
    
    init(offset: Int, limit: Int) {
        self.offset = offset
        self.limit = limit
    }
    
    var url: URL? { URL(string: Endpoint.users.rawValue) }
    var queryParameters: [String : String]? {
        ["offset": "\(offset)", "limit": "\(limit)"]
    }
}
