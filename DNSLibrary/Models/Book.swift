//
//  Book.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Foundation

struct Book: Sendable, Hashable {
	let id: String
	let author: String
	let bookName: String
	let publicationYear: Int
}

extension Book {
	init(
		author: String,
		bookName: String,
		publicationYear: Int
	) {
		self.init(id: UUID().uuidString,
				  author: author,
				  bookName: bookName,
				  publicationYear: publicationYear)
	}
	
	init() {
		self.init(id: UUID().uuidString,
				  author: "",
				  bookName: "",
				  publicationYear: -1)
	}
}
