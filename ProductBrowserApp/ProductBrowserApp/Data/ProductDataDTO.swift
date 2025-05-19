//
//  ProductDataDTO.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import Foundation

struct ProductDataDTO: Decodable, DomainConvertible {
    typealias DomainModel = ProductDataModel
    
    let id: Int
    let title: String
    let price: Float
    let description: String
    let images: [String]
    
    func toDomain() -> DomainModel {
        return ProductDataModel(
            id: id,
            title: title,
            price: price,
            description: description,
            images: images.compactMap { URL(string: $0) }
            )
    }
}
