//
//  AppCoordinator.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

final class AppCoordinator: Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController = UINavigationController()

    private var tabBarController: UITabBarController = UITabBarController()
    private var productCoordinator: ProductCoordinator!
    private var settingsCoordinator: SettingsCoordinator!

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        setupTabs()
        configureTabBarAppearance()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    private func setupTabs() {
        productCoordinator = ProductCoordinator()
        productCoordinator.start()

        settingsCoordinator = SettingsCoordinator()
        settingsCoordinator.start()

        productCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(systemName: "cart"),
            tag: 0
        )

        settingsCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            tag: 1
        )
        
        tabBarController.viewControllers = [
            productCoordinator.navigationController,
            settingsCoordinator.navigationController
        ]
    }
    
    func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.isTranslucent = false
    }
}
