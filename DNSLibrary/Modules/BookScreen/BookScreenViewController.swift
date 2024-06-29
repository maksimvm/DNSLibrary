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
	}
	
	private func binding() {
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
