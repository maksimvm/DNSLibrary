//  
//  BookScreenViewController.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Combine
import UIKit

final class BookScreenViewController: UIViewController {
	
	enum Action { }
    
    // MARK: - Outlets
    
    // MARK: - Data
    var viewModel: BookScreenViewModel!
	let action: PassthroughSubject<Action, Never> = PassthroughSubject<Action, Never>()
    private var cancellables: Set<AnyCancellable> = []
	private let collectionView: BookScreenUICollectionView = BookScreenUICollectionView(frame: .zero)
		
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
		viewModel.$bookModel
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				self?.collectionView.configure(model)
			}
			.store(in: &cancellables)
		collectionView.action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
				case .editBookName(let filledText):
					print("editBookName=\(filledText)")
				case .editAuthor(let filledText):
					print("editAuthor=\(filledText)")
				case .editPublicationYear(let filledText):
					print("editPublicationYear=\(filledText)")
				}
			}
			.store(in: &cancellables)
		action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				switch action {
					
				}
			}
			.store(in: &cancellables)
	}
	
	private func configureNavigationBar() {
		navigationItem.title = ""
		navigationItem.largeTitleDisplayMode = .never
		navigationController?.navigationBar.prefersLargeTitles = false
	}

    // MARK: - Actions
}
