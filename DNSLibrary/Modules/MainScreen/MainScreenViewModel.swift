//  
//  MainScreenViewModel.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Combine
import Foundation

final class MainScreenViewModel {
	
	enum Action { }
	
	// MARK: - Data
	@Published
	var libraryModel: [Book] = [Book]()
	var action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private var cancellables: Set<AnyCancellable> = []
	
	init() {
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
					
				}
			}
			.store(in: &cancellables)
		libraryModel = [
			Book(author: "Test",
				 bookName: "Test2",
				 publicationYear: 1995),
			Book(author: "1996",
				 bookName: "1996",
				 publicationYear: 1996),
			Book(author: "1997",
				 bookName: "1997",
				 publicationYear: 1997),
			Book(author: "1998",
				 bookName: "1998",
				 publicationYear: 1998)
		]
	}
}
