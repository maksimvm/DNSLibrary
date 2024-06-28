//  
//  MainScreenAssembly.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Foundation

final class MainScreenAssembly {
	
	// MARK: - Data
	private var viewController: MainScreenViewController?
	private let coordinator: MainCoordinator
	
	@MainActor
	var view: MainScreenViewController {
		guard let view: MainScreenViewController = viewController else {
			viewController = MainScreenViewController()
			configureModule(viewController)
			return viewController!
		}
		return view
	}
	
	init(coordinator: MainCoordinator) {
		self.coordinator = coordinator
	}
	
	@MainActor
	private func configureModule(_ view: MainScreenViewController?) {
		guard let view else { return }
		view.viewModel = MainScreenViewModel()
		view.coordinator = coordinator
	}
}
