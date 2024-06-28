//
//  UICollectionView + Extenstion.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

extension UICollectionView {
	/// UICollectionView enums for all cases used in project.
	enum UICollectionViewType {
		case mainScreenUICollectionView
	}
	
	/// Registers cells for provided UICollectionViewType.
	///
	/// Each time UICollectionView is created it requires cell to be registered. This simple function provides you all necessary cells nib for required case.
	///
	/// ```swift
	/// collectionView.registerCells(.mainScreenUICollectionView)
	/// ```
	///
	/// - Parameter type: ``UICollectionViewType``.
	func registerCells(_ type: UICollectionViewType) {
		switch type {
		case .mainScreenUICollectionView:
			register(MainScreenUICollectionViewCollectionViewCell.self,
					 forCellWithReuseIdentifier: MainScreenUICollectionViewCollectionViewCell.reuseIdentifier)
			register(MainScreenPlaceholderUICollectionViewCollectionViewCell.self,
					 forCellWithReuseIdentifier: MainScreenPlaceholderUICollectionViewCollectionViewCell.reuseIdentifier)
		}
	}
}
