//
//  ApiDataSource.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation
import Combine

protocol ApiDataSourceProtocol {
    func fetchProducts(request: NetworkRequest) -> AnyPublisher<[ProductDataDTO], NetworkError>
}

class ApiDataSource: ApiDataSourceProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchProducts(request: NetworkRequest) -> AnyPublisher<[ProductDataDTO], NetworkError> {
        return networkService.performRequest(request)
    }
}
