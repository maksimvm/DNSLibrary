//
//  MainScreenUICollectionView.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Combine
import UIKit

final class MainScreenUICollectionView: UICollectionView {
	
	enum Action {
		case editBook
	}

	private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
	
	private enum Section: Int {
		case books
		case placeholer
	}
	
	private enum Item: Hashable {
		case book(book: Book)
		case placeholder
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
		isScrollEnabled = true
		isPagingEnabled = false
		allowsMultipleSelection = false
		collectionViewLayout = compositionalLayout
		dataSource = diffableDataSource
		registerCells(.mainScreenUICollectionView)
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
		case .book(let book):
			if let cell: MainScreenUICollectionViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenUICollectionViewCollectionViewCell.reuseIdentifier,
																										   for: indexPath) as? MainScreenUICollectionViewCollectionViewCell {
				cell.action
					.receive(on: DispatchQueue.main)
					.sink { [weak self] action in
						switch action {
							
						case .editBook:
							self?.action.send(.editBook)
						}
					}
					.store(in: &cancellables)
				return cell
			}
		case .placeholder:
			if let cell: MainScreenPlaceholderUICollectionViewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenPlaceholderUICollectionViewCollectionViewCell.reuseIdentifier,
																													  for: indexPath) as? MainScreenPlaceholderUICollectionViewCollectionViewCell {
				return cell
			}
		}

		return UICollectionViewCell()
	}
	
	private func configureLayout() -> UICollectionViewLayout {
		let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
			guard let self = self else { return self?.createPlaceholderLayout() }
			let section: Section = self.diffableDataSource.snapshot().sectionIdentifiers[sectionIndex]
			switch section {
			case .books:
				return self.createBookLayout()
			case .placeholer:
				return self.createPlaceholderLayout()
			}
		}
		return layout
	}
	
	private func createPlaceholderLayout() -> NSCollectionLayoutSection {
		let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																	  heightDimension: .fractionalHeight(1))
		let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																	   heightDimension: .fractionalHeight(1))
		let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
																				subitems: [item])
		let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
		return section
	}
	
	private func createBookLayout() -> NSCollectionLayoutSection {
		let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																	  heightDimension: .estimated(1))
		let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																	   heightDimension: .estimated(1))
		let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
																				subitems: [item])
		let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
		return section
	}
	
	func configure(_ model: [Book]) {
		isScrollEnabled = !model.isEmpty
		var snapshot: Snapshot = Snapshot()
		if model.isEmpty {
			snapshot.appendSections([.placeholer])
			snapshot.appendItems([.placeholder],
								 toSection: .placeholer)
		} else {
			snapshot.appendSections([.books])
			snapshot.appendItems(model.map { .book(book: $0) },
								 toSection: .books)
		}
		diffableDataSource.apply(snapshot,
								 animatingDifferences: true)
	}
}
