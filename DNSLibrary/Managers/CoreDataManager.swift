//
//  CoreDataManager.swift
//  DNSLibrary
//
//  Created by Максим Громов on 01.07.2024.
//

import CoreData
import Foundation

final class CoreDataManager: Sendable {
	
	// MARK: - Data
	static let shared: CoreDataManager = CoreDataManager(modelName: "Library")
	private let container: NSPersistentContainer
	private var context: NSManagedObjectContext {
		return container.viewContext
	}
	
	private init(modelName: String) {
		container = NSPersistentContainer(name: modelName)
	}
	
	// MARK: - Actions
	func load(actionHandler: @escaping () -> Void) {
		container.loadPersistentStores { _, error in
			if let error {
				fatalError(error.localizedDescription)
			} else {
				actionHandler()
			}
		}
	}
	
	func createBook(
		bookName: String? = nil,
		author: String? = nil,
		publicationYear: String? = nil
	) -> Book {
		let book: Book = Book(context: context)
		book.id = UUID()
		book.bookName = bookName ?? ""
		book.author = author ?? ""
		book.publicationYear = publicationYear ?? ""
		return book
	}
	
	func loadBooks(
		sortField: BookField = .author,
		sortOrder: SortOrder = .ascending
	) -> [Book] {
		let request: NSFetchRequest<Book> = Book.fetchRequest()
		var sortDescriptor: NSSortDescriptor
		switch sortField {
		case .bookName:
			sortDescriptor = NSSortDescriptor(keyPath: \Book.bookName,
											  ascending: sortOrder == .ascending)
		case .author:
			sortDescriptor = NSSortDescriptor(keyPath: \Book.author,
											  ascending: sortOrder == .ascending)
		case .publicationYear:
			sortDescriptor = NSSortDescriptor(keyPath: \Book.publicationYear,
											  ascending: sortOrder == .ascending)
		}
		request.sortDescriptors = [sortDescriptor]
		return (try? context.fetch(request)) ?? []
	}
	
	func deleteBook(book: Book) {
		context.delete(book)
		save()
	}
	
	func save() {
		if context.hasChanges {
			try? context.save()
		}
	}
}
