//
//  ProductDetailPresenter.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 19.05.25.
//

import Foundation

protocol ProductDetailPresenterProtocol {
    func viewDidLoad()
    func getImage(at index: Int) -> URL
    func toggleFavorite()
    var imagesCount: Int { get }
}

protocol ProductDetailView: AnyObject {
    func display(product: ProductItem)
}

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    private let product: ProductItem
    private let repository: DataRepositoryProtocol
    weak var view: ProductDetailView?
    var imagesCount: Int { product.images.count }
    
    init(view: ProductDetailView?, product: ProductItem, repository: DataRepositoryProtocol) {
        self.product = product
        self.repository = repository
        self.view = view
    }

    func viewDidLoad() {
        view?.display(product: product)
    }
    
    func getImage(at index: Int) -> URL {
        product.images[index]
    }

    func toggleFavorite(){
        repository.toggleFavorite(id: product.id)
    }
}
