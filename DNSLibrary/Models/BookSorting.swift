//
//  BookSorting.swift
//  DNSLibrary
//
//  Created by Максим Громов on 30.06.2024.
//

import Foundation

enum BookField: Int, Sendable {
	case bookName
	case author
	case publicationYear
}

enum SortOrder: Sendable {
	case ascending
	case descending
}
