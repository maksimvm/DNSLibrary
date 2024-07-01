//
//  Optional+Extension.swift
//  DNSLibrary
//
//  Created by Максим Громов on 30.06.2024.
//

import Foundation

extension Optional where Wrapped == String {
	var orEmpty: String {
		self ?? ""
	}
}
