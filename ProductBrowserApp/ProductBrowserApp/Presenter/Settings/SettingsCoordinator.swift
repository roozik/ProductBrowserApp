//
//  SettingsCoordinator.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController = UINavigationController()

    // ideally here also should be mvp, I have done like this just to save time, not create more classes, etc.
    func start() {
        let settingsVC = SettingsViewController(settingsDataSource: UserDefaultsSettingsDataSource())
        //        let presenter = SettingsPresenter(view: settingsVC)
        //        settingsVC.presenter = presenter
        navigationController.viewControllers = [settingsVC]
    }
}
