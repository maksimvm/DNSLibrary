//  
//  BookScreenViewModel.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Combine
import Foundation

final class BookScreenViewModel {
	
	enum Action { 
		case saveBookName(name: String)
		case saveAuthor(author: String)
		case savePublicationYear(publicationYear: String)
		case saveBook
		case deleteBook
	}
	
	// MARK: - Data
	@Published
	private(set) var book: Book?
	@Published
	private(set) var isSaveButtonEnabled: Bool = false
	@Published
	private(set) var isDeleteButtonEnabled: Bool
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private var cancellables: Set<AnyCancellable> = []
	private let actionHandler: ((BookScreenAction) -> Void)
	private var initialBook: Book?
	
	init(
		book: Book?,
		actionHandler: @escaping ((BookScreenAction) -> Void)
	) {
		if let book {
			self.book = book
			initialBook = book
			isDeleteButtonEnabled = true
		} else {
			isDeleteButtonEnabled = false
		}
		self.actionHandler = actionHandler
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
				case .saveBookName(let name):
					self?.saveBookName(name: name)
				case .saveAuthor(let author):
					self?.saveAuthor(author: author)
				case .savePublicationYear(let publicationYear):
					self?.savePublicationYear(publicationYear: publicationYear)
				case .saveBook:
					self?.saveBook()
				case .deleteBook:
					self?.deleteBook()
				}
			}
			.store(in: &cancellables)
	}
	
	private func saveBookName(name: String) {
		if !name.isEmpty {
			if book != nil {
				book?.bookName = name
			} else {
				let newBook: Book = Book(bookName: name,
								   author: "",
								   publicationYear: "")
				book = newBook
			}
		}
		compareInitialBookWithEditedOne()
	}
	
	private func saveAuthor(author: String) {
		if !author.isEmpty {
			if book != nil {
				book?.author = author
			} else {
				let newBook: Book = Book(bookName: "",
										 author: author,
										 publicationYear: "")
				book = newBook
			}
		}
		compareInitialBookWithEditedOne()
	}
	
	private func savePublicationYear(publicationYear: String) {
		if !publicationYear.isEmpty {
			if book != nil {
				book?.publicationYear = publicationYear
			} else {
				let newBook: Book = Book(bookName: "",
										 author: "",
										 publicationYear: publicationYear)
				book = newBook
			}
		}
		compareInitialBookWithEditedOne()
	}
	
	private func compareInitialBookWithEditedOne() {
		if let book {
			if let initialBook {
				isSaveButtonEnabled = !book.bookName.isEmpty && !book.author.isEmpty && !book.publicationYear.isEmpty && book != initialBook
			} else {
				isSaveButtonEnabled = !book.bookName.isEmpty && !book.author.isEmpty && !book.publicationYear.isEmpty
			}
		}
	}
	
	private func saveBook() {
		actionHandler(.reloadData)
	}
	
	private func deleteBook() {
		actionHandler(.reloadData)
	}
}
