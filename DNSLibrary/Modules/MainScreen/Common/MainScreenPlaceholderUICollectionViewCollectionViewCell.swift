//
//  MainScreenPlaceholderUICollectionViewCollectionViewCell.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import UIKit

final class MainScreenPlaceholderUICollectionViewCollectionViewCell: UICollectionViewCell {
    
	// MARK: - Data
	private lazy var placeholderImage: UIImageView = {
		let placeholderImage: UIImageView = UIImageView()
		placeholderImage.translatesAutoresizingMaskIntoConstraints = false
		placeholderImage.backgroundColor = ThemeManager.currentTheme().generalColor
		placeholderImage.contentMode = .scaleAspectFit
		placeholderImage.image = UIImage(named: "MainScreen/PlaceholderImage")
		return placeholderImage
	}()
	private lazy var noBooksLabel: UILabel = {
		let bookName: UILabel = UILabel()
		bookName.translatesAutoresizingMaskIntoConstraints = false
		bookName.font = UIFont.systemFont(ofSize: 18)
		bookName.textColor = ThemeManager.currentTheme().generalTitleColor
		bookName.numberOfLines = 0
		bookName.textAlignment = .center
		bookName.text = NSLocalizedString("mainScreenNoBooksLabelText", comment: "")
		return bookName
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = ThemeManager.currentTheme().generalColor
		contentView.addSubview(placeholderImage)
		contentView.addSubview(noBooksLabel)
		NSLayoutConstraint.activate([
			placeholderImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
			placeholderImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
			placeholderImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
			noBooksLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4),
			noBooksLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 4),
			noBooksLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			noBooksLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16),
			noBooksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
		])
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
}