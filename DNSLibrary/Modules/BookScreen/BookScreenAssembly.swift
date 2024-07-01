//  
//  BookScreenAssembly.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Foundation

final class BookScreenAssembly {
    
	// MARK: - Data
    private var viewController: BookScreenViewController?
    private var book: Book?
	private let coordinator: MainCoordinator
	private let coreDataManager: CoreDataManager
    
	@MainActor
    var view: BookScreenViewController {
		guard let view: BookScreenViewController = viewController else {
            viewController = BookScreenViewController()
            configureModule(viewController)
            return viewController!
        }
        return view
    }
	
	convenience init(coordinator: MainCoordinator) {
		self.init(book: nil,
				  coordinator: coordinator,
				  coreDataManager: CoreDataManager.shared)
	}
	
	convenience init(
		book: Book,
		coordinator: MainCoordinator
	) {
		self.init(book: book,
				  coordinator: coordinator,
				  coreDataManager: CoreDataManager.shared)
	}
	
	init(
		book: Book?,
		coordinator: MainCoordinator,
		coreDataManager: CoreDataManager
	) {
		self.book = book
		self.coordinator = coordinator
		self.coreDataManager = coreDataManager
	}
    
	@MainActor
    private func configureModule(_ view: BookScreenViewController?) {
        guard let view else { return }
		view.viewModel = BookScreenViewModel(book: book, coreDataManager: coreDataManager)
		view.coordinator = coordinator
    }
}
