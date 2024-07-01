//
//  BookScreenUICollectionViewCollectionViewCell.swift
//  DNSLibrary
//
//  Created by Максим Громов on 30.06.2024.
//

import Combine
import UIKit

final class BookScreenUICollectionViewCollectionViewCell: UICollectionViewCell {
	
	enum Action {
		case editBook
	}
    
	// MARK: - Data
	private(set) var action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private lazy var infoLabel: UILabel = {
		let infoLabel: UILabel = UILabel()
		infoLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.font = UIFont.systemFont(ofSize: 18)
		infoLabel.textColor = ThemeManager.currentTheme().generalTitleColor
		infoLabel.numberOfLines = 1
		infoLabel.textAlignment = .left
		return infoLabel
	}()
	private lazy var titleLabel: UILabel = {
		let titleLabel: UILabel = UILabel()
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.font = UIFont.systemFont(ofSize: 16)
		titleLabel.textColor = ThemeManager.currentTheme().generalBlueColor
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .left
		return titleLabel
	}()
	private lazy var borderView: UIView = {
		let borderView: UIView = UIView()
		borderView.backgroundColor = ThemeManager.currentTheme().generalTitleColor
		borderView.translatesAutoresizingMaskIntoConstraints = false
		return borderView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = ThemeManager.currentTheme().generalColor
		contentView.addSubview(infoLabel)
		contentView.addSubview(titleLabel)
		contentView.addSubview(borderView)
		NSLayoutConstraint.activate([
			infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			titleLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 4),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			borderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
			borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			borderView.heightAnchor.constraint(equalToConstant: 1)
		])
		let cellTapGestureRecognizerp: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
																					   action: #selector(editField))
		contentView.addGestureRecognizer(cellTapGestureRecognizerp)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		action = PassthroughSubject<Action, Never>()
	}
	
	func configure(
		title: String,
		bookField: BookField
	) {
		switch bookField {
		case .bookName:
			infoLabel.text = NSLocalizedString("bookScreenBookNameLabelText", comment: "")
		case .author:
			infoLabel.text = NSLocalizedString("bookScreenAuthorLabelText", comment: "")
		case .publicationYear:
			infoLabel.text = NSLocalizedString("bookScreenPublicationDateLabelText", comment: "")
		}
		if title.isEmpty {
			titleLabel.text = NSLocalizedString("bookScreenEmptyFieldLabelText", comment: "")
		} else {
			titleLabel.text = title
		}
	}
	
	// MARK: - Actions
	@objc
	private func editField() {
		action.send(.editBook)
	}
}
