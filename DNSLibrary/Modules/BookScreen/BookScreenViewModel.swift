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
	private let coreDataManager: CoreDataManager
	private var cancellables: Set<AnyCancellable> = []
	private var initialBook: Book?
	
	init(
		book: Book?,
		coreDataManager: CoreDataManager
	) {
		if let book {
			self.book = book
			initialBook = book
			isDeleteButtonEnabled = true
		} else {
			isDeleteButtonEnabled = false
		}
		self.coreDataManager = coreDataManager
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
					self?.coreDataManager.save()
				case .deleteBook:
					if let book: Book = self?.initialBook {
						self?.coreDataManager.deleteBook(book: book)
					} else if let book: Book = self?.book {
						self?.coreDataManager.deleteBook(book: book)
					}
				}
			}
			.store(in: &cancellables)
	}
	
	private func saveBookName(name: String) {
		if !name.isEmpty {
			if book != nil {
				book?.bookName = name
				self.book = book
			} else {
				book = coreDataManager.createBook(bookName: name)
			}
		}
		compareInitialBookWithEditedOne()
	}
	
	private func saveAuthor(author: String) {
		if !author.isEmpty {
			if book != nil {
				book?.author = author
				self.book = book
			} else {
				book = coreDataManager.createBook(author: author)
			}
		}
		compareInitialBookWithEditedOne()
	}
	
	private func savePublicationYear(publicationYear: String) {
		if !publicationYear.isEmpty {
			if book != nil {
				book?.publicationYear = publicationYear
				self.book = book
			} else {
				book = coreDataManager.createBook(publicationYear: publicationYear)
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
}
