//
//  MainViewController.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var viewModel: MainViewModelProtocol = MainViewModel.init(messageStorage: CoreDataMessageStorage.init())
    
    @IBOutlet weak var messageTableView: UITableView! {
        didSet {
            messageTableView.delegate = self
            messageTableView.dataSource = self
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    private func bindViewModel() {
        self.viewModel.refreshTrigger
            .sink { [weak self] type in
                switch type {
                case .all:
                    self?.messageTableView.reloadData()
                case .oneRow:
                    self?.insertTableRowAtTop()
                }
            }
            .store(in: &cancellables)
    }
    
    private func insertTableRowAtTop() {
        let indexPath: IndexPath = .init(row: 0, section: 0)
        self.messageTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - User Interaction
    
    @IBAction func didTapAddMesssageButton(_ sender: UIBarButtonItem) {
        self.viewModel.didTapAddMesssageButton()
    }
}

// MARK: - UITableViewDataSource, Delegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "MessageCell")
        var config = cell.defaultContentConfiguration()
        
        let date = self.viewModel.sortedMessages[indexPath.row].date
        let contents = self.viewModel.sortedMessages[indexPath.row].contents
        let cellText = "\(date) - \(contents)"
        
        config.text = cellText
        cell.contentConfiguration = config
        
        return cell
    }
}
