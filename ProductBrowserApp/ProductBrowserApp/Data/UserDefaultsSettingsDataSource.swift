//
//  UserDefaultsSettingsDataSource.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 19.05.25.
//

import Foundation

protocol SettingsDataSourceProtocol {
    func isDarkModeEnabled() -> Bool
    func setDarkMode(enabled: Bool)
}

final class UserDefaultsSettingsDataSource: SettingsDataSourceProtocol {
    private enum Keys {
        static let isDarkMode = "isDarkMode"
    }
    
    func isDarkModeEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: Keys.isDarkMode)
    }
    
    func setDarkMode(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: Keys.isDarkMode)
    }
}
