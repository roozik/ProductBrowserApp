//
//  ProductItem.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 18.05.25.
//

import Foundation

final class ProductItem: Hashable {
    
    let id: Int
    let title: String
    let price: String
    let description: String
    let images: [URL]
    var isFavorite = false
    
    init(product: ProductDataModel){
        self.id = product.id
        self.title = product.title
        self.price = "\(product.price) euro"
        self.description = product.description
        self.images = product.images
    }
    
    static func == (lhs: ProductItem, rhs: ProductItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
