//
//  SceneDelegate.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let isDarkMode = UserDefaultsSettingsDataSource().isDarkModeEnabled()
        window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
