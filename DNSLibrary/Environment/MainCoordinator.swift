//
//  MainCoordinator.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

final class MainCoordinator: Coordinator {
	
	// MARK: - Data
	private(set) var navigationController: UINavigationController
	private lazy var mainScreenAssembly = MainScreenAssembly(coordinator: self)
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Actions
	@MainActor
	func start() {
		navigationController.pushViewController(mainScreenAssembly.view,
												animated: false)
	}
	
	func addBook() {
		let bookScreenAssembly: BookScreenAssembly = BookScreenAssembly(coordinator: self)
		navigationController.pushViewController(bookScreenAssembly.view,
												animated: true)
	}
	
	func viewBook(book: Book) {
		let bookScreenAssembly: BookScreenAssembly = BookScreenAssembly(book: book, coordinator: self)
		navigationController.pushViewController(bookScreenAssembly.view,
												animated: true)
	}
	
	func sortBooks(
		sortField: BookField,
		sortOrder: SortOrder,
		actionHandler: @escaping (BookField, SortOrder) -> Void
	) {
		var bookNameSortActionTitle: String = NSLocalizedString("sortBooksScreenBookNameSortActionText", comment: "")
		var authorSortActionTitle: String = NSLocalizedString("sortBooksScreenAuthorSortActionText", comment: "")
		var publicationDateSortActionTitle: String = NSLocalizedString("sortBooksScreenPublicationYearSortActionText", comment: "")
		switch sortField {
		case .bookName:
			bookNameSortActionTitle.append(sortOrder == .ascending ? " ↑ ✓" : " ↓ ✓")
		case .author:
			authorSortActionTitle.append(sortOrder == .ascending ? " ↑ ✓" : " ↓ ✓")
		case .publicationYear:
			publicationDateSortActionTitle.append(sortOrder == .ascending ? " ↑ ✓" : " ↓ ✓")
		}
		let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("sortBooksScreenTitleText", comment: ""),
																		 message: nil,
																		 preferredStyle: .actionSheet)
		let bookNameSortAction: UIAlertAction = UIAlertAction(title: bookNameSortActionTitle, style: .default) { _ in
			actionHandler(.bookName, sortOrder == .ascending ? .descending : .ascending)
		}
		let authorSortAction: UIAlertAction = UIAlertAction(title: authorSortActionTitle, style: .default) { _ in
			actionHandler(.author, sortOrder == .ascending ? .descending : .ascending)
		}
		let publicationDateSortAction: UIAlertAction = UIAlertAction(title: publicationDateSortActionTitle, style: .default) { _ in
			actionHandler(.publicationYear, sortOrder == .ascending ? .descending : .ascending)
		}
		let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("sortBooksScreenCancelActionText", comment: ""), style: .cancel)
		actionSheetController.addAction(bookNameSortAction)
		actionSheetController.addAction(authorSortAction)
		actionSheetController.addAction(publicationDateSortAction)
		actionSheetController.addAction(cancelAction)
		navigationController.present(actionSheetController,
									 animated: true)
	}
	
	func editBook(
		bookField: BookField,
		text: String,
		actionHandler: @escaping (String) -> Void
	) {
		var alertControllerTitleText: String
		switch bookField {
		case .bookName:
			alertControllerTitleText = NSLocalizedString("booksScreenEditBookNameAlertTitleText", comment: "")
		case .author:
			alertControllerTitleText = NSLocalizedString("booksScreenEditAuthorAlertTitleText", comment: "")
		case .publicationYear:
			alertControllerTitleText = NSLocalizedString("booksScreenEditPublicationYearAlertTitleText", comment: "")
		}
		let alertController: UIAlertController = UIAlertController(title: alertControllerTitleText,
																   message: nil,
																   preferredStyle: .alert)
		alertController.addTextField { textField in
			textField.placeholder = alertControllerTitleText
			if !text.isEmpty {
				textField.text = text
			}
		}
		let submitAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("booksScreenAlertSubmitActionTitleText", comment: ""), style: .default) { _ in
			if let text: String = alertController.textFields?.first?.text {
				actionHandler(text)
			}
		}
		alertController.addAction(submitAction)
		let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("booksScreenAlertCancelActionTitleText", comment: ""), style: .cancel)
		alertController.addAction(cancelAction)
		navigationController.present(alertController,
									 animated: true)
	}
	
	func popViewController() {
		navigationController.popViewController(animated: true)
	}
}
