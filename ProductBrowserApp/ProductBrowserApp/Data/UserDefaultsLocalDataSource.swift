//
//  UserDefaultsLocalDataSource.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 19.05.25.
//

import Foundation

// Since the problem scope was simple and time-constrained,
// I chose to persist data using UserDefaults instead of integrating a full database like Realm.
// The stored data (e.g. favorite product IDs, dark mode setting) is lightweight and not sensitive.
// This approach avoids unnecessary model/database boilerplate.
//
// If needed, we can later replace UserDefaults with a more robust DB like Realm or CoreData.
// Thanks to protocol-based abstraction (LocalDataSourceProtocol, etc.),
// those changes will be isolated to the data layer only.

final class UserDefaultsLocalDataSource: LocalDataSourceProtocol {
    private enum Keys {
        static let favoriteProductIDs = "favoriteProductIDs"
    }
    
    private var favorites: Set<Int> {
        get {
            let array = UserDefaults.standard.array(forKey: Keys.favoriteProductIDs) as? [Int] ?? []
            return Set(array)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: Keys.favoriteProductIDs)
        }
    }

    func isFavorite(id: Int) -> Bool {
        return favorites.contains(id)
    }

    func toggleFavorite(id: Int) {
        var set = favorites
        if set.contains(id) {
            set.remove(id)
        } else {
            set.insert(id)
        }
        favorites = set
    }

    func favoriteIDs() -> Set<Int> {
        return favorites
    }
}
