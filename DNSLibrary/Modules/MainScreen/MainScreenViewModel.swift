//  
//  MainScreenViewModel.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Combine
import Foundation

final class MainScreenViewModel {
	
	enum Action { 
		case sortBooks(sortField: BookField, sortOrder: SortOrder)
		case searchBooks(selectedScopeButtonIndex: Int, searchText: String)
		case reloadData
	}
	
	// MARK: - Data
	@Published
	private(set) var library: [Book] = [Book]()
	private(set) var chosenSortField: BookField = .bookName
	private(set) var chosenSortOrder: SortOrder = .ascending
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private var cancellables: Set<AnyCancellable> = []
	private var initialLibrary: [Book] = [Book]()
	
	init() {
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
				case .sortBooks(let sortField, let sortOrder):
					self?.sortBook(sortField: sortField, sortOrder: sortOrder)
				case .reloadData:
					self?.loadData()
				case .searchBooks(let selectedScopeButtonIndex, let searchText):
					self?.searchBooks(selectedScopeButtonIndex: selectedScopeButtonIndex, searchText: searchText)
				}
			}
			.store(in: &cancellables)
		library = [
			Book(bookName: "Test2",
				 author: "Test",
				 publicationYear: "1995"),
			Book(bookName: "1996",
				 author: "1996",
				 publicationYear: "1996"),
			Book(bookName: "1997",
				 author: "1997",
				 publicationYear: "1997"),
			Book(bookName: "1998",
				 author: "1998",
				 publicationYear: "1998")
		]
		initialLibrary = [
			Book(bookName: "Test2",
				 author: "Test",
				 publicationYear: "1995"),
			Book(bookName: "1996",
				 author: "1996",
				 publicationYear: "1996"),
			Book(bookName: "1997",
				 author: "1997",
				 publicationYear: "1997"),
			Book(bookName: "1998",
				 author: "1998",
				 publicationYear: "1998")
		]
	}
	
	private func loadData() {
		
	}
	
	private func sortBook(
		sortField: BookField,
		sortOrder: SortOrder
	) {
		chosenSortField = sortField
		chosenSortOrder = sortOrder
		switch sortField {
		case .bookName:
			if sortOrder == .ascending {
				library.sort(by: { $0.bookName > $1.bookName })
			} else {
				library.sort(by: { $0.bookName < $1.bookName })
			}
			
		case .author:
			if sortOrder == .ascending {
				library.sort(by: { $0.author > $1.author })
			} else {
				library.sort(by: { $0.author < $1.author })
			}
		case .publicationYear:
			if sortOrder == .ascending {
				library.sort(by: { $0.publicationYear > $1.publicationYear })
			} else {
				library.sort(by: { $0.publicationYear < $1.publicationYear })
			}
		}
	}
	
	private func searchBooks(
		selectedScopeButtonIndex: Int,
		searchText: String
	) {
		if searchText.isEmpty {
			library = initialLibrary
		} else {
			if selectedScopeButtonIndex == 0 {
				library = initialLibrary.filter { $0.bookName.contains(searchText) }
			} else if selectedScopeButtonIndex == 1 {
				library = initialLibrary.filter { $0.author.contains(searchText) }
			} else {
				library = initialLibrary.filter { $0.publicationYear.contains(searchText) }
			}
		}
	}
}
