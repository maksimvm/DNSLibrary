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
	
	func editBook(book: Book) {
		let bookScreenAssembly: BookScreenAssembly = BookScreenAssembly(book: book) { _ in }
		navigationController.pushViewController(bookScreenAssembly.view,
												animated: true)
	}
	
	func sortBooks(
		sortingOption: SortingOption,
		sortingType: SortingType,
		actionHandler: @escaping (SortingOption, SortingType) -> Void
	) {
		var bookNameSortActionTitle: String = NSLocalizedString("sortBooksScreenBookNameSortActionText", comment: "")
		var authorSortActionTitle: String = NSLocalizedString("sortBooksScreenAuthorSortActionText", comment: "")
		var publicationDateSortActionTitle: String = NSLocalizedString("sortBooksScreenPublicationYearSortActionText", comment: "")
		switch sortingOption {
		case .bookName:
			bookNameSortActionTitle.append(sortingType == .ascending ? " ↑ ✓" : " ↓ ✓")
		case .author:
			authorSortActionTitle.append(sortingType == .ascending ? " ↑ ✓" : " ↓ ✓")
		case .publicationDate:
			publicationDateSortActionTitle.append(sortingType == .ascending ? " ↑ ✓" : " ↓ ✓")
		}
		let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("sortBooksScreenTitleText", comment: ""),
																		 message: nil,
																		 preferredStyle: .actionSheet)
		let bookNameSortAction: UIAlertAction = UIAlertAction(title: bookNameSortActionTitle, style: .default) { _ in
			actionHandler(.bookName, sortingType == .ascending ? .descending : .ascending)
		}
		let authorSortAction: UIAlertAction = UIAlertAction(title: authorSortActionTitle, style: .default) { _ in
			actionHandler(.author, sortingType == .ascending ? .descending : .ascending)
		}
		let publicationDateSortAction: UIAlertAction = UIAlertAction(title: publicationDateSortActionTitle, style: .default) { _ in
			actionHandler(.publicationDate, sortingType == .ascending ? .descending : .ascending)
		}
		let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("sortBooksScreenCancelActinText", comment: ""), style: .cancel)
		actionSheetController.addAction(bookNameSortAction)
		actionSheetController.addAction(authorSortAction)
		actionSheetController.addAction(publicationDateSortAction)
		actionSheetController.addAction(cancelAction)
		navigationController.present(actionSheetController,
									 animated: true, 
									 completion: nil)
	}
}
