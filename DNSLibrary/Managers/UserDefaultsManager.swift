//
//  UserDefaultsManager.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Foundation

final class UserDefaultsManager: Sendable {
	
	// MARK: - Keys
	enum UserDefaultsManagerKeys: String {
		case currentTheme
	}
	
	// MARK: - Data
	static let shared: UserDefaultsManager = UserDefaultsManager()
	private var userDefaults: UserDefaults { .standard }
	
	private init() {}
	
	func updateObject(
		for key: UserDefaultsManagerKeys,
		data: Any?
	) {
		userDefaults.setValue(data, forKey: key.rawValue)
	}
	
	func getCurrentStringObjectState(for key: UserDefaultsManagerKeys) -> String? {
		return userDefaults.string(forKey: key.rawValue)
	}
}
