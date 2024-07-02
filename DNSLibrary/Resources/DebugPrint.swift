//
//  DebugPrint.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Foundation

/// Wrapper around swift print for printing messages in console only in debug mode.
func print(
	_ items: Any...,
	separator: String = " ",
	terminator: String = "\n"
) {
	#if DEBUG
	items.forEach {
		Swift.print($0,
					separator: separator,
					terminator: terminator)
	}
	#endif
}
