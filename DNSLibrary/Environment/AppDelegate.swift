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
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {
		configureAppWindow()
		
		return true
	}
	
	/// Function that creates app window and main coordinator.
	private func configureAppWindow() {
		let window: UIWindow = UIWindow()
		self.window = window
	}
}
