//
//  Book.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Foundation

struct Book: Sendable, Hashable {
	let id: String
	var bookName: String
	var author: String
	var publicationYear: String
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
