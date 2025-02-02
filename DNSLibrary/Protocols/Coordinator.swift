//
//  Coordinator.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

@MainActor
protocol Coordinator {
	var navigationController: UINavigationController { get }
	
	func start()
	func addBook()
}
