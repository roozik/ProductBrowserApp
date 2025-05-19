//
//  SettingsViewController.swift
//  ProductBrowserApp
//
//  Created by Ruzanna on 17.05.25.
//

import UIKit

final class SettingsViewController: UIViewController {
    let settingsDataSource: SettingsDataSourceProtocol
    @IBOutlet weak var appearanceSwitch: UISwitch!
    
    var isDark: Bool = false {
        didSet {
            overrideInterfaceStyleGlobally()
        }
    }
    
    init(settingsDataSource: SettingsDataSourceProtocol) {
        self.settingsDataSource = settingsDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        isDark = settingsDataSource.isDarkModeEnabled()
        appearanceSwitch.isOn = isDark
    }
    
    private func overrideInterfaceStyleGlobally() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.overrideUserInterfaceStyle = isDark ? .dark : .light
    }
    
    @IBAction func appearanceSwitchChanged(_ sender: UISwitch) {
        isDark = sender.isOn
        settingsDataSource.setDarkMode(enabled: isDark)
    }
}
