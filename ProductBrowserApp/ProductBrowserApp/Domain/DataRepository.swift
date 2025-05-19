//
//  DataRepository.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation
import Combine

protocol DataRepositoryProtocol {
    func fetchProducts(page: Int) -> AnyPublisher<[ProductItem], NetworkError>
    func toggleFavorite(id: Int)
    func isFavorite(id: Int) -> Bool
}

final class DataRepository: DataRepositoryProtocol {
    let apiDataSoure: ApiDataSourceProtocol
    let localDataSource: LocalDataSourceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiDataSoure: ApiDataSourceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.apiDataSoure = apiDataSoure
        self.localDataSource = localDataSource
    }
    
    func fetchProducts(page: Int) -> AnyPublisher<[ProductItem], NetworkError> {
        return apiDataSoure.fetchProducts(request: RequestProvider.init(offset: page, limit: 10))
            .map { [weak self] productDataModels in
                productDataModels.toDomain().map { model in
                    let item = ProductItem(product: model)
                    item.isFavorite = self?.localDataSource.isFavorite(id: item.id) ?? false
                    return item
                }
            }
            .eraseToAnyPublisher()
    }
    
    func toggleFavorite(id: Int) {
        localDataSource.toggleFavorite(id: id)
    }
    
    func isFavorite(id: Int) -> Bool {
        localDataSource.isFavorite(id: id)
    }
}
