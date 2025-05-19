//
//  LocalDataSourceProtocol.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 19.05.25.
//

protocol LocalDataSourceProtocol {
    func isFavorite(id: Int) -> Bool
    func toggleFavorite(id: Int)
    func favoriteIDs() -> Set<Int>
}
