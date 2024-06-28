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
	var coordinator: MainCoordinator!
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
		configureNavigationBar()
		binding()
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
	
	private func configureNavigationBar() {
		navigationItem.title = NSLocalizedString("mainScreenTitleText", comment: "")
		navigationItem.largeTitleDisplayMode = .automatic
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func binding() {
		viewModel.$libraryModel
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				self?.collectionView.configure(model)
			}
			.store(in: &cancellables)
	}
	
	// MARK: - Actions
}
