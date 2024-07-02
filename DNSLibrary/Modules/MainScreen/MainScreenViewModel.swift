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
	}
	
	// MARK: - Data
	@Published
	private(set) var library: [Book] = []
	private(set) var chosenSortField: BookField = .bookName
	private(set) var chosenSortOrder: SortOrder = .ascending
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private var cancellables: Set<AnyCancellable> = []
	private let coreDataManager: CoreDataManager
	private let debouncer: Debouncer = Debouncer()
	
	init(coreDataManager: CoreDataManager) {
		self.coreDataManager = coreDataManager
		coreDataManager.load { [weak self] in
			self?.loadBooks()
		}
		NotificationCenter.default.addObserver(self,
											   selector: #selector(loadBooks),
											   name: .NSManagedObjectContextDidSave,
											   object: nil)
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
				case .sortBooks(let sortField, let sortOrder):
					self?.sortBook(sortField: sortField, sortOrder: sortOrder)
				case .searchBooks(let selectedScopeButtonIndex, let searchText):
					self?.searchBooks(selectedScopeButtonIndex: selectedScopeButtonIndex, searchText: searchText)
				}
			}
			.store(in: &cancellables)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc
	private func loadBooks() {
		library = coreDataManager.loadBooks()
	}
	
	private func sortBook(
		sortField: BookField,
		sortOrder: SortOrder
	) {
		chosenSortField = sortField
		chosenSortOrder = sortOrder
		library = coreDataManager.loadBooks(sortField: sortField,
											sortOrder: sortOrder)
	}
	
	private func searchBooks(
		selectedScopeButtonIndex: Int,
		searchText: String
	) {
		if searchText.isEmpty {
			loadBooks()
		} else {
			debouncer.debounce(for: 0.5) { [weak self] in
				guard let self else { return }
				if selectedScopeButtonIndex == 0 {
					self.library = self.coreDataManager.loadBooks().filter { $0.bookName.contains(searchText) }
				} else if selectedScopeButtonIndex == 1 {
					self.library = self.coreDataManager.loadBooks().filter { $0.author.contains(searchText) }
				} else {
					self.library = self.coreDataManager.loadBooks().filter { $0.publicationYear.contains(searchText) }
				}
			}
		}
	}
}
