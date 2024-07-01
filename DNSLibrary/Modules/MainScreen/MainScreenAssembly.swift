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
	private let coreDataManager: CoreDataManager
	
	@MainActor
	var view: MainScreenViewController {
		guard let view: MainScreenViewController = viewController else {
			viewController = MainScreenViewController()
			configureModule(viewController)
			return viewController!
		}
		return view
	}
	
	convenience init(coordinator: MainCoordinator) {
		self.init(coreDataManager: CoreDataManager.shared,
				  coordinator: coordinator)
	}
	
	init(
		coreDataManager: CoreDataManager,
		coordinator: MainCoordinator
	) {
		self.coreDataManager = coreDataManager
		self.coordinator = coordinator
	}
	
	@MainActor
	private func configureModule(_ view: MainScreenViewController?) {
		guard let view else { return }
		view.viewModel = MainScreenViewModel(coreDataManager: coreDataManager)
		view.coordinator = coordinator
	}
}
