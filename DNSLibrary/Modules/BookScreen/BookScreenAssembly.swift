//  
//  BookScreenAssembly.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Foundation

enum BookScreenAction {
	case reloadData
}

final class BookScreenAssembly {
    
	// MARK: - Data
    private var viewController: BookScreenViewController?
    private var book: Book?
	private let coordinator: MainCoordinator
	private let actionHandler: ((BookScreenAction) -> Void)
    
	@MainActor
    var view: BookScreenViewController {
		guard let view: BookScreenViewController = viewController else {
            viewController = BookScreenViewController()
            configureModule(viewController)
            return viewController!
        }
        return view
    }
	
	convenience init(
		coordinator: MainCoordinator,
		actionHandler: @escaping (BookScreenAction) -> Void
	) {
		self.init(book: nil,
				  coordinator: coordinator,
				  actionHandler: actionHandler)
	}
	
	init(
		book: Book?,
		coordinator: MainCoordinator,
		actionHandler: @escaping (BookScreenAction) -> Void
	) {
		self.book = book
		self.coordinator = coordinator
		self.actionHandler = actionHandler
	}
    
	@MainActor
    private func configureModule(_ view: BookScreenViewController?) {
        guard let view else { return }
		view.viewModel = BookScreenViewModel(book: book, actionHandler: actionHandler)
		view.coordinator = coordinator
    }
}
