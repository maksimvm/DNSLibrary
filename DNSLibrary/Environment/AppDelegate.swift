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
	var coordinator: MainCoordinator?
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		ThemeManager.applyTheme(theme: ThemeManager.currentTheme())
		configureAppWindow()
		
		return true
	}
	
	/// Function that creates app window and main coordinator.
	private func configureAppWindow() {
		let navigationController: UINavigationController = UINavigationController()
		coordinator = MainCoordinator(navigationController: navigationController)
		coordinator?.start()
		window = UIWindow()
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}
}
