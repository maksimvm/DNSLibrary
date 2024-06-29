//
//  MainScreenUICollectionViewCollectionViewCell.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Combine
import UIKit

final class MainScreenUICollectionViewCollectionViewCell: UICollectionViewCell {
    
	enum Action {
		case editBook
	}
	
	// MARK: - Data
	var action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private lazy var bookNameLabel: UILabel = {
		let bookName: UILabel = UILabel()
		bookName.translatesAutoresizingMaskIntoConstraints = false
		bookName.font = UIFont.systemFont(ofSize: 18)
		bookName.textColor = ThemeManager.currentTheme().generalTitleColor
		bookName.numberOfLines = 1
		bookName.textAlignment = .left
		bookName.text = NSLocalizedString("mainScreenBookNameLabelText", comment: "")
		return bookName
	}()
	private lazy var authorLabel: UILabel = {
		let bookName: UILabel = UILabel()
		bookName.translatesAutoresizingMaskIntoConstraints = false
		bookName.font = UIFont.systemFont(ofSize: 16)
		bookName.textColor = ThemeManager.currentTheme().generalTitleColor
		bookName.numberOfLines = 1
		bookName.textAlignment = .left
		bookName.text = NSLocalizedString("mainScreenAuthorLabelText", comment: "")
		return bookName
	}()
	private lazy var publicationYearLabel: UILabel = {
		let bookName: UILabel = UILabel()
		bookName.translatesAutoresizingMaskIntoConstraints = false
		bookName.font = UIFont.systemFont(ofSize: 14)
		bookName.textColor = ThemeManager.currentTheme().generalTitleColor
		bookName.numberOfLines = 1
		bookName.textAlignment = .left
		bookName.text = NSLocalizedString("mainScreenPublicationDateLabelText", comment: "")
		return bookName
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.backgroundColor = ThemeManager.currentTheme().generalColor
		contentView.addSubview(bookNameLabel)
		contentView.addSubview(authorLabel)
		contentView.addSubview(publicationYearLabel)
		NSLayoutConstraint.activate([
			bookNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			bookNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			authorLabel.topAnchor.constraint(equalTo: bookNameLabel.bottomAnchor, constant: 4),
			authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			publicationYearLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
			publicationYearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			publicationYearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
		])
		let cellTapGestureRecognizerp: UITapGestureRecognizer = UITapGestureRecognizer(target: self, 
																					   action: #selector(editBook))
		contentView.addGestureRecognizer(cellTapGestureRecognizerp)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		action = PassthroughSubject<Action, Never>()
	}
	
	func configure(_ book: Book) {
		
	}
	
	// MARK: - Actions
	@objc 
	private func editBook() {
		action.send(.editBook)
	}
}
