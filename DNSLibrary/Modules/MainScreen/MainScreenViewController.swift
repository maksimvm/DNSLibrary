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
			}
			.store(in: &cancellables)
		collectionView.action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				guard let self else { return }
				switch action {
				case .editBook:
					print("editbook")
				}
			}
			.store(in: &cancellables)
	}
	
	private func configureNavigationBar() {
		navigationItem.title = NSLocalizedString("mainScreenTitleText", comment: "")
		navigationItem.backButtonTitle = ""
		navigationItem.largeTitleDisplayMode = .automatic
		navigationController?.navigationBar.prefersLargeTitles = true
		let addBookUIBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus")?.withTintColor(ThemeManager.currentTheme().generalSymbolColor),
																	  style: .plain,
																	  target: self,
																	  action: #selector(addBook))
		let sortBooksUIBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down")?.withTintColor(ThemeManager.currentTheme().generalSymbolColor),
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
		print("addBook")
		coordinator?.addBook()
	}
	
	@objc 
	private func sortBooks() {
		print("sortBooks")
	}
}
