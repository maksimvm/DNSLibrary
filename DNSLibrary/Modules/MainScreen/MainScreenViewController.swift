//  
//  MainScreenViewController.swift
//  DNSLibrary
//
//  Created by Максим Громов on 28.06.2024.
//

import Combine
import UIKit

final class MainScreenViewController: UIViewController {
		
	// MARK: - Data
	var viewModel: MainScreenViewModel!
	weak var coordinator: MainCoordinator?
	private var cancellables: Set<AnyCancellable> = []
	private lazy var launchImageView: UIImageView = {
		let launchImageView: UIImageView = UIImageView()
		launchImageView.contentMode = .center
		launchImageView.image = UIImage(named: "LaunchScreenImage")
		launchImageView.translatesAutoresizingMaskIntoConstraints = false
		return launchImageView
	}()
	private lazy var searchController: UISearchController = {
		let searchController: UISearchController = UISearchController()
		searchController.searchBar.delegate = self
		searchController.searchBar.placeholder = NSLocalizedString("mainScreenSearchBarPlaceholderText", comment: "")
		searchController.searchBar.scopeButtonTitles = [
			NSLocalizedString("mainScreenBookNameLabelText", comment: ""),
			NSLocalizedString("mainScreenAuthorLabelText", comment: ""),
			NSLocalizedString("mainScreenPublicationDateLabelText", comment: "")
		]
		return searchController
	}()
	private let collectionView: MainScreenUICollectionView = MainScreenUICollectionView(frame: .zero)
	
	override init(
		nibName nibNameOrNil: String?,
		bundle nibBundleOrNil: Bundle?
	) {
		super.init(nibName: nibNameOrNil, 
				   bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
		binding()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureNavigationBar()
	}
	
	private func configureView() {
		view.backgroundColor = ThemeManager.currentTheme().generalColor
		navigationItem.searchController = searchController
		view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
		])
		if let navigationController: UINavigationController = coordinator?.navigationController {
			navigationController.view.addSubview(launchImageView)
			NSLayoutConstraint.activate([
				launchImageView.topAnchor.constraint(equalTo: navigationController.view.topAnchor, constant: 0),
				launchImageView.leadingAnchor.constraint(equalTo: navigationController.view.leadingAnchor, constant: 0),
				launchImageView.bottomAnchor.constraint(equalTo: navigationController.view.bottomAnchor, constant: 0),
				launchImageView.trailingAnchor.constraint(equalTo: navigationController.view.trailingAnchor, constant: 0)
			])
		}
	}
	
	private func binding() {
		viewModel.$library
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				guard let self else { return }
				if self.launchImageView.alpha == 1 {
					UIView.animate(withDuration: 0.5) {
						self.launchImageView.alpha = 0
					} completion: { _ in
						self.launchImageView.removeFromSuperview()
					}
				}
				self.collectionView.configure(model)
				self.navigationItem.rightBarButtonItems?.last?.isEnabled = model.count > 1
			}
			.store(in: &cancellables)
		collectionView.action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
				case .editBook(let book):
					self?.coordinator?.viewBook(book: book)
				}
			}
			.store(in: &cancellables)
	}
	
	private func configureNavigationBar() {
		navigationItem.title = NSLocalizedString("mainScreenTitleText", comment: "")
		navigationItem.backButtonTitle = ""
		navigationItem.largeTitleDisplayMode = .automatic
		navigationController?.navigationBar.prefersLargeTitles = true
		let addBookUIBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(ThemeManager.currentTheme().generalBlueColor),
																	  style: .plain,
																	  target: self,
																	  action: #selector(addBook))
		let sortBooksUIBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down")?.withTintColor(ThemeManager.currentTheme().generalBlueColor),
																		style: .plain,
																		target: self,
																		action: #selector(sortBooks))
		navigationItem.rightBarButtonItems = [
			addBookUIBarButtonItem,
			sortBooksUIBarButtonItem
		]
	}
	
	// MARK: - Actions
	@objc 
	private func addBook() {
		coordinator?.addBook()
	}
	
	@objc 
	private func sortBooks() {
		coordinator?.sortBooks(sortField: viewModel.chosenSortField, sortOrder: viewModel.chosenSortOrder) { [weak self] sortField, sortOrder  in
			self?.viewModel.action.send(.sortBooks(sortField: sortField, sortOrder: sortOrder))
		}
	}
}

// MARK: - UISearchBarDelegate
extension MainScreenViewController: UISearchBarDelegate {
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		searchBar.setShowsScope(true,
								animated: true)
		return true
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsScope(false,
								animated: true)
	}
	
	func searchBar(
		_ searchBar: UISearchBar,
		textDidChange searchText: String
	) {
		viewModel.action.send(.searchBooks(selectedScopeButtonIndex: searchBar.selectedScopeButtonIndex, searchText: searchText))
	}
	
	func searchBar(
		_ searchBar: UISearchBar,
		selectedScopeButtonIndexDidChange selectedScope: Int
	) {
		viewModel.action.send(.searchBooks(selectedScopeButtonIndex: selectedScope, searchText: searchBar.searchTextField.text ?? ""))
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		viewModel.action.send(.searchBooks(selectedScopeButtonIndex: searchBar.selectedScopeButtonIndex, searchText: searchBar.searchTextField.text ?? ""))
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		viewModel.action.send(.searchBooks(selectedScopeButtonIndex: searchBar.selectedScopeButtonIndex, searchText: ""))
	}
}
