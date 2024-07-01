//
//  UICollectionViewCell+Extension.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

extension UICollectionViewCell {
	static var reuseIdentifier: String {
		return String(describing: Self.self)
	}
}
