//
//  ProductListPresenter.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation
import Combine

protocol ProductListPresenterProtocol {
    func loadData()
    func loadNextPageIfNeeded()
    func refreshData()
    func refreshFavoriteStates()
    func openProductDetails(at index: Int)
    func toggleFavorite(for id: Int)
    var currentPage: Int { get }
}

enum DataResult<T> {
  case loading
  case success([T])
  case error(NetworkError?)
}

protocol ProductListView: AnyObject {
    func updateData(_ data: DataResult<ProductItem>)
    func updateSingleItem(_ item: ProductItem)
}

final class ProductListPresenter: ProductListPresenterProtocol {
    private let repository: DataRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var items: [ProductItem] = []
    private weak var productListView: ProductListView?
    private weak var coordinator: ProductCoordinator?
    private var isFetching = false
    private(set) var currentPage: Int = 0
    private var selectedProduct: ProductItem?
    
    init(repository: DataRepositoryProtocol, productListView: ProductListView?, coordinator: ProductCoordinator?){
        self.repository = repository
        self.productListView = productListView
        self.coordinator = coordinator
    }
    
    func loadData(){
        if currentPage == 0, items.isEmpty {
            productListView?.updateData(.loading)
        }
        repository.fetchProducts(page: currentPage)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                isFetching = false
                if case let .failure(error) = completion {
                    productListView?.updateData(.error(error))
                }
            }, receiveValue: { [weak self] data in
                guard let self else { return }
                if currentPage == 0 {
                    items.removeAll()
                }
                if data.isEmpty, currentPage > 0 {
                    currentPage -= 1
                }
                let existingIds = Set(items.map { $0.id })
                let filteredItems = data.filter { !existingIds.contains($0.id) }
                
                items.append(contentsOf: filteredItems)
                productListView?.updateData(.success(filteredItems))
            })
            .store(in: &cancellables)
    }
    
    func refreshFavoriteStates() {
        guard let product = selectedProduct else { return }
        product.isFavorite = repository.isFavorite(id: product.id)
        productListView?.updateSingleItem(product)
        selectedProduct = nil
    }
    
    func openProductDetails(at index: Int) {
        let product = items[index]
        selectedProduct = product
        coordinator?.showProductDetail(for: product)
    }
    
    func loadNextPageIfNeeded() {
        guard !isFetching || items.count < 10 else { return } // page limit = 10, beter to set as const
        isFetching = true
        currentPage += 1
        loadData()
    }
    
    func refreshData() {
        isFetching = true
        currentPage = 0
        self.loadData()
    }
    
    func toggleFavorite(for id: Int) {
        repository.toggleFavorite(id: id)
    }

}
