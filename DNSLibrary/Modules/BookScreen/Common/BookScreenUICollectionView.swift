//
//  BookScreenUICollectionView.swift
//  DNSLibrary
//
//  Created by Максим Громов on 30.06.2024.
//

import Combine
import UIKit

final class BookScreenUICollectionView: UICollectionView {
	
	enum Action {
		case editBookName
		case editAuthor
		case editPublicationYear
	}
	
	private typealias DataSource = UICollectionViewDiffableDataSource<BookField, Item>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<BookField, Item>
	
	private enum Item: Hashable {
		case bookName(bookName: String)
		case author(author: String)
		case publicationYear(publicationYear: String)
	}

	// MARK: - Data
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
	private var cancellables: Set<AnyCancellable> = []
	private lazy var diffableDataSource: DataSource = configureDataSource()
	private lazy var compositionalLayout: UICollectionViewLayout  = configureLayout()
	
	convenience init(frame: CGRect) {
		self.init(frame: frame,
				  collectionViewLayout: UICollectionViewLayout())
	}
	
	override init(
		frame: CGRect,
		collectionViewLayout layout: UICollectionViewLayout
	) {
		super.init(frame: frame,
				   collectionViewLayout: layout)
		translatesAutoresizingMaskIntoConstraints = false
		backgroundColor = ThemeManager.currentTheme().generalColor
		showsHorizontalScrollIndicator = false
		showsVerticalScrollIndicator = false
		isScrollEnabled = false
		isPagingEnabled = false
		allowsMultipleSelection = false
		collectionViewLayout = compositionalLayout
		dataSource = diffableDataSource
		registerCells(.bookScreenUICollectionView)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func configureDataSource() -> DataSource {
		let dataSource: DataSource = DataSource(collectionView: self, cellProvider: { [weak self] collectionView, indexPath, item in
			guard let self else { return UICollectionViewCell() }
			return self.cell(collectionView: collectionView,
							 indexPath: indexPath,
							 item: item)
		})
		return dataSource
	}
	
	private func cell(
		collectionView: UICollectionView,
		indexPath: IndexPath,
		item: Item
	) -> UICollectionViewCell {
		switch item {
		case .bookName(let bookName):
			if let cell: BookScreenUICollectionViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BookScreenUICollectionViewCollectionViewCell.reuseIdentifier,
																										   for: indexPath) as? BookScreenUICollectionViewCollectionViewCell {
				cell.configure(title: bookName,
							   bookField: .bookName)
				cell.action
					.receive(on: DispatchQueue.main)
					.sink { [weak self] action in
						switch action {
						case .editBook:
							self?.action.send(.editBookName)
						}
					}
					.store(in: &cancellables)
				return cell
			}
		case .author(let author):
				if let cell: BookScreenUICollectionViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BookScreenUICollectionViewCollectionViewCell.reuseIdentifier,
																											   for: indexPath) as? BookScreenUICollectionViewCollectionViewCell {
					cell.configure(title: author,
								   bookField: .author)
					cell.action
						.receive(on: DispatchQueue.main)
						.sink { [weak self] action in
							switch action {
							case .editBook:
								self?.action.send(.editAuthor)
							}
						}
						.store(in: &cancellables)
					return cell
				}
		case .publicationYear(let publicationYear):
			if let cell: BookScreenUICollectionViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BookScreenUICollectionViewCollectionViewCell.reuseIdentifier,
																										   for: indexPath) as? BookScreenUICollectionViewCollectionViewCell {
				cell.configure(title: publicationYear,
							   bookField: .publicationYear)
				cell.action
					.receive(on: DispatchQueue.main)
					.sink { [weak self] action in
						switch action {
						case .editBook:
							self?.action.send(.editPublicationYear)
						}
					}
					.store(in: &cancellables)
				return cell
			}
		}
		return UICollectionViewCell()
	}
	
	private func configureLayout() -> UICollectionViewLayout {
		let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
			return self?.createLayout()
		}
		return layout
	}
	
	private func createLayout() -> NSCollectionLayoutSection {
		let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																	  heightDimension: .estimated(50))
		let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																	   heightDimension: .estimated(1))
		let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
																				subitems: [item])
		let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
		return section
	}
	
	func configure(_ model: Book?) {
		var snapshot: Snapshot = Snapshot()
		snapshot.appendSections([
			.bookName,
			.author,
			.publicationYear
		])
		if let model {
			snapshot.appendItems([
				.bookName(bookName: model.bookName)
			],
								 toSection: .bookName)
			snapshot.appendItems([
				.author(author: model.author)
			],
								 toSection: .author)
			snapshot.appendItems([
				.publicationYear(publicationYear: model.publicationYear)
			],
								 toSection: .publicationYear)
		} else {
			snapshot.appendItems([
				.bookName(bookName: "")
			],
								 toSection: .bookName)
			snapshot.appendItems([
				.author(author: "")
			],
								 toSection: .author)
			snapshot.appendItems([
				.publicationYear(publicationYear: "")
			],
								 toSection: .publicationYear)
		}
		diffableDataSource.apply(snapshot,
								 animatingDifferences: true)
	}
}
