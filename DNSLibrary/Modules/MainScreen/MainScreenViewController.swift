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
	private let collectionView: MainScreenUICollectionView = MainScreenUICollectionView(frame: .zero)
	
	override init(
		nibName nibNameOrNil: String?,
		bundle nibBundleOrNil: Bundle?
	) {
		super.init(nibName: nibNameOrNil, 
				   bundle: nibBundleOrNil)
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
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
		view.addSubview(collectionView)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
		])
	}
	
	private func binding() {
		viewModel.$libraryModel
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				self?.collectionView.configure(model)
				self?.navigationItem.rightBarButtonItems?.last?.isEnabled = model.count > 1
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
		coordinator?.sortBooks(sortingOption: viewModel.chosenSortingOption, sortingType: viewModel.chosenSortingOptionType) { [weak self] sortingOption, sortingType  in
			self?.viewModel.action.send(.sortBooks(sortingOption: sortingOption, sortingType: sortingType))
		}
	}
}
