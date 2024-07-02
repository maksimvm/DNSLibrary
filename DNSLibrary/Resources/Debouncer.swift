//
//  Debouncer.swift
//  DNSLibrary
//
//  Created by Максим Громов on 02.07.2024.
//

import Foundation

/// Debouncer class for delaying search in http request.
final class Debouncer {
	// MARK: - Data
	/// A variable determing if search is already in progress.
	private var pendingWorkItem: DispatchWorkItem?
	
	/// Creates a delay in search http request in specified time.
	///
	/// - Parameters:
	///   - timeInterval: Specific time delay for search request.
	///   - queue: Type of queue used for delaying request.
	///   - block: Escaping closure for request.
	func debounce(
		for timeInterval: TimeInterval,
		on queue: DispatchQueue = .main,
		block: @escaping () -> Void
	) {
		pendingWorkItem?.cancel()
		let workItem: DispatchWorkItem = DispatchWorkItem(block: block)
		pendingWorkItem = workItem
		let deadline: DispatchTime = DispatchTime.now() + timeInterval
		queue.asyncAfter(deadline: deadline,
						 execute: workItem)
	}
}
