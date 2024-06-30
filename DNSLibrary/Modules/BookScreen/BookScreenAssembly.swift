//  
//  BookScreenAssembly.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Foundation

enum BookScreenAction {
}

final class BookScreenAssembly {
    
	// MARK: - Data
    private var viewController: BookScreenViewController?
    private var book: Book?
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
	
	convenience init(actionHandler: @escaping (BookScreenAction) -> Void) {
		self.init(book: nil,
				  actionHandler: actionHandler)
	}
	
	init(
		book: Book?,
		actionHandler: @escaping (BookScreenAction) -> Void
	) {
		self.book = book
		self.actionHandler = actionHandler
	}
    
	@MainActor
    private func configureModule(_ view: BookScreenViewController?) {
        guard let view else { return }
		view.viewModel = BookScreenViewModel(book: book, actionHandler: actionHandler)
    }
}
