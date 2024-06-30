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
		case sortBooks(sortingOption: SortingOption, sortingType: SortingType)
	}
	
	// MARK: - Data
	@Published
	private(set) var libraryModel: [Book] = [Book]()
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private(set) var chosenSortingOption: SortingOption = .bookName
	private(set) var chosenSortingOptionType: SortingType = .ascending
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
				case .sortBooks(let sortingOption, let sortingType):
					self?.sortBook(sortingOption: sortingOption, sortingType: sortingType)
				}
			}
			.store(in: &cancellables)
		libraryModel = [
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
	
	private func sortBook(
		sortingOption: SortingOption,
		sortingType: SortingType
	) {
		chosenSortingOption = sortingOption
		chosenSortingOptionType = sortingType
		switch sortingOption {
		case .bookName:
			if sortingType == .ascending {
				libraryModel.sort(by: { $0.bookName > $1.bookName })
			} else {
				libraryModel.sort(by: { $0.bookName < $1.bookName })
			}
			
		case .author:
			if sortingType == .ascending {
				libraryModel.sort(by: { $0.author > $1.author })
			} else {
				libraryModel.sort(by: { $0.author < $1.author })
			}
		case .publicationDate:
			if sortingType == .ascending {
				libraryModel.sort(by: { $0.publicationYear > $1.publicationYear })
			} else {
				libraryModel.sort(by: { $0.publicationYear < $1.publicationYear })
			}
		}
	}
}
