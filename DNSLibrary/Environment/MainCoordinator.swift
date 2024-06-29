//
//  MainCoordinator.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
	
	// MARK: - Data
	var navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Actions
	@MainActor 
	func start() {
		let mainScreenAssembly = MainScreenAssembly(coordinator: self)
		navigationController.pushViewController(mainScreenAssembly.view,
												animated: false)
	}
	
	func addBook() {
		let bookScreenAssembly: BookScreenAssembly = BookScreenAssembly { _ in }
		navigationController.pushViewController(bookScreenAssembly.view,
												animated: true)
	}
}
