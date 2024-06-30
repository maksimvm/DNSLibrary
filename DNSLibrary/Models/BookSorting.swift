//
//  BookSorting.swift
//  DNSLibrary
//
//  Created by Максим Громов on 30.06.2024.
//

import Foundation

enum SortingOption: Sendable {
	case bookName
	case author
	case publicationDate
}

enum SortingType: Sendable {
	case ascending
	case descending
}
