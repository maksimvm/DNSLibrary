//
//  Book+CoreDataProperties.swift
//  DNSLibrary
//
//  Created by Максим Громов on 01.07.2024.
//
//

import CoreData
import Foundation

extension Book {

	// MARK: - Data
    @NSManaged public var id: UUID!
    @NSManaged public var bookName: String!
    @NSManaged public var publicationYear: String!
    @NSManaged public var author: String!
	
	// MARK: - Actions
	@nonobjc
	static func fetchRequest() -> NSFetchRequest<Book> {
		return NSFetchRequest<Book>(entityName: "Book")
	}
}

// MARK: - Identifiable
extension Book: Identifiable {}

// MARK: - @unchecked Sendable
extension Book: @unchecked Sendable {}
