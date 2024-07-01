//
//  ThemeManager.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

struct ThemeManager {
	@MainActor 
	static func applyTheme(theme: Theme) {
		UserDefaultsManager.shared.updateObject(for: .currentTheme,
												data: theme.rawValue)
		let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = ThemeManager.currentTheme().generalColor
		appearance.titleTextAttributes = [.foregroundColor: ThemeManager.currentTheme().generalTitleColor]
		appearance.largeTitleTextAttributes = [.foregroundColor: ThemeManager.currentTheme().generalTitleColor]
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance
	}
	
	static func currentTheme() -> Theme {
		if let theme: String = UserDefaultsManager.shared.getCurrentStringObjectState(for: .currentTheme) {
			return Theme(rawValue: theme)!
		}
		return .light
	}
}

enum Theme: String {
	case light
	case dark
	
	var generalColor: UIColor {
		switch self {
		case .light:
			return .white
		case .dark:
			return .black
		}
	}
	
	var generalTitleColor: UIColor {
		switch self {
		case .light:
			return .black
		case .dark:
			return .white
		}
	}
	
	var generalBlueColor: UIColor {
		return .blue
	}
	
	var generalRedColor: UIColor {
		return .red
	}
}
