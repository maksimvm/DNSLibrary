//
//  AppDelegate.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
	
	// MARK: - Data
	var window: UIWindow?
	private(set) var coordinator: MainCoordinator?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		configureAppTheme()
		configureAppWindow()
		configureCoreData()
		
		return true
	}
	
	/// Function that sets light or dark theme as a default theme.
	private func configureAppTheme() {
		if UITraitCollection.current.userInterfaceStyle == .light {
			ThemeManager.applyTheme(theme: .light)
		} else {
			ThemeManager.applyTheme(theme: .dark)
		}
	}
	
	/// Function that creates app window and main coordinator.
	private func configureAppWindow() {
		let navigationController: UINavigationController = UINavigationController()
		coordinator = MainCoordinator(navigationController: navigationController)
		window = UIWindow()
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
	
	/// Function that creates calls to CoreData manager and awaits storage loading.
	private func configureCoreData() {
		CoreDataManager.shared.load { [weak self] in
			self?.coordinator?.start()
		}
	}
}
