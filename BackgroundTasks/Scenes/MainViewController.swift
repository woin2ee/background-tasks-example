//
//  MainViewController.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let messageStorage: CoreDataMessageStorage = .init()
    
    @IBOutlet weak var messageTableView: UITableView! {
        didSet {
            messageTableView.delegate = self
            messageTableView.dataSource = self
        }
    }
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageStorage.getMessages { result in
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(_):
                //FIXME: Message 를 가져오지 못했습니다. Alert
                return
            }
        }
    }
    
    @IBAction func didTapAddMesssageButton(_ sender: UIBarButtonItem) {
        self.addMessage(contents: "Contents...")
        self.updateTableRow()
    }
    
    private func addMessage(contents: String) {
        let message: Message = .init(date: Date(), contents: contents)
        messageStorage.save(message)
        self.messages.append(message)
    }
    
    private func updateTableRow() {
        let indexPath: IndexPath = .init(row: 0, section: 0)
        self.messageTableView.insertRows(at: [indexPath], with: .automatic)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "MessageCell")
        var config = cell.defaultContentConfiguration()
        
        let messages = self.messages.sorted(by: { $0.date > $1.date })
        let date = messages[indexPath.row].date
        let contents = messages[indexPath.row].contents
        let cellText = "\(date) - \(contents)"
        
        config.text = cellText
        cell.contentConfiguration = config
        
        return cell
    }
}
