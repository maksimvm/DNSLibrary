//  
//  BookScreenViewModel.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Combine
import Foundation

final class BookScreenViewModel {
	
	enum Action { }
	
	// MARK: - Data
	@Published
	private(set) var bookModel: Book?
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private var cancellables: Set<AnyCancellable> = []
	private let actionHandler: ((BookScreenAction) -> Void)
	
	init(
		book: Book?,
		actionHandler: @escaping ((BookScreenAction) -> Void)
	) {
		if let book {
			bookModel = book
		}
		self.actionHandler = actionHandler
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
					
				}
			}
			.store(in: &cancellables)
	}
}
