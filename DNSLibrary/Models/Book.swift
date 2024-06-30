//
//  Book.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Foundation

struct Book: Sendable, Hashable {
	let id: String
	let bookName: String
	let author: String
	let publicationYear: String
}

extension Book {
	init(
		bookName: String,
		author: String,
		publicationYear: String
	) {
		self.init(id: UUID().uuidString,
				  bookName: bookName,
				  author: author,
				  publicationYear: publicationYear)
	}
	
	init() {
		self.init(id: UUID().uuidString,
				  bookName: "",
				  author: "",
				  publicationYear: "")
	}
}
