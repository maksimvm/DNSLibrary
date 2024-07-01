//  
//  BookScreenViewController.swift
//  DNSLibrary
//
//  Created by Максим Громов on 29.06.2024.
//

import Combine
import UIKit

final class BookScreenViewController: UIViewController {
	
    // MARK: - Data
    var viewModel: BookScreenViewModel!
	weak var coordinator: MainCoordinator?
    private var cancellables: Set<AnyCancellable> = []
	private let collectionView: BookScreenUICollectionView = BookScreenUICollectionView(frame: .zero)
	private lazy var saveButton: UIButton = {
		let saveButton: UIButton = UIButton()
		saveButton.translatesAutoresizingMaskIntoConstraints = false
		saveButton.setTitle(NSLocalizedString("booksScreenSaveButtonTitleText", comment: ""),
							for: [])
		saveButton.setTitleColor(ThemeManager.currentTheme().generalColor,
								 for: [])
		saveButton.backgroundColor = ThemeManager.currentTheme().generalBlueColor
		saveButton.layer.cornerRadius = 8
		saveButton.addTarget(self,
							 action: #selector(saveButtonIsPressed),
							 for: .touchUpInside)
		return saveButton
	}()
	private lazy var deleteButton: UIButton = {
		let deleteButton: UIButton = UIButton()
		deleteButton.translatesAutoresizingMaskIntoConstraints = false
		deleteButton.setTitle(NSLocalizedString("booksScreenDeleteButtonTitleText", comment: ""),
							  for: [])
		deleteButton.setTitleColor(ThemeManager.currentTheme().generalColor,
								   for: [])
		deleteButton.backgroundColor = ThemeManager.currentTheme().generalRedColor
		deleteButton.layer.cornerRadius = 8
		deleteButton.addTarget(self,
							   action: #selector(deleteButtonIsPressed),
							   for: .touchUpInside)
		return deleteButton
	}()
		
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
		view.addSubview(saveButton)
		view.addSubview(deleteButton)
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
			deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
			deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			deleteButton.heightAnchor.constraint(equalToConstant: 44),
			saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			saveButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -16),
			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			saveButton.heightAnchor.constraint(equalToConstant: 44)
		])
	}
	
	private func binding() {
		viewModel.$book
			.receive(on: DispatchQueue.main)
			.sink { [weak self] model in
				self?.collectionView.configure(model)
			}
			.store(in: &cancellables)
		viewModel.$isSaveButtonEnabled
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isEnabled in
				self?.saveButton.isEnabled = isEnabled
				self?.saveButton.alpha = isEnabled ? 1 : 0.1
			}
			.store(in: &cancellables)
		viewModel.$isDeleteButtonEnabled
			.receive(on: DispatchQueue.main)
			.sink { [weak self] isEnabled in
				self?.deleteButton.isEnabled = isEnabled
				self?.deleteButton.alpha = isEnabled ? 1 : 0.1
			}
			.store(in: &cancellables)
		collectionView.action
			.receive(on: DispatchQueue.main)
			.sink { [weak self] action in
				guard let self else { return }
				switch action {
				case .editBookName:
					self.coordinator?.editBook(bookField: .bookName, text: self.viewModel.book?.bookName ?? "") { bookName in
						self.viewModel.action.send(.saveBookName(name: bookName))
					}
				case .editAuthor:
					self.coordinator?.editBook(bookField: .author, text: self.viewModel.book?.bookName ?? "") { author in
						self.viewModel.action.send(.saveAuthor(author: author))
					}
				case .editPublicationYear:
					self.coordinator?.editBook(bookField: .publicationYear, text: self.viewModel.book?.bookName ?? "") { publicationYear in
						self.viewModel.action.send(.savePublicationYear(publicationYear: publicationYear))
					}
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
	@objc
	private func saveButtonIsPressed() {
		viewModel.action.send(.saveBook)
	}
	
	@objc
	private func deleteButtonIsPressed() {
		viewModel.action.send(.deleteBook)
	}
}
