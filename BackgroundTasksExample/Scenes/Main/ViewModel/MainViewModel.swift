//
//  MainViewModel.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/19.
//

import Foundation
import Combine
import OSLog

enum RefreshType {
    case all
    case oneRow
}

protocol MainViewModelInputProtocol {
    func viewWillAppear()
    func fetchLatestMessages()
    func didTapAddMesssageButton()
}

protocol MainViewModelOutputProtocol {
    var messages: [Message] { get }
    var sortedMessages: [Message] { get }
    var refreshTrigger: PassthroughSubject<RefreshType, Never> { get }
}

protocol MainViewModelProtocol: MainViewModelInputProtocol, MainViewModelOutputProtocol {}

final class MainViewModel: MainViewModelProtocol {
    
    private var messageStorage: MessageStorage
    
    // MARK: - Output
    
    private(set) var messages: [Message] = []
    var sortedMessages: [Message] {
        messages.sorted(by: { $0.date > $1.date })
    }
    var refreshTrigger: PassthroughSubject<RefreshType, Never> = .init()
    
    // MARK: - Initialization
    
    init(messageStorage: MessageStorage) {
        self.messageStorage = messageStorage
    }
    
    // MARK: - Input
    
    func viewWillAppear() {
        self.fetchLatestMessages()
    }
    
    func fetchLatestMessages() {
        messageStorage.getMessages { result in
            switch result {
            case .success(let messages):
                self.messages = messages
                self.refreshTrigger.send(.all)
            case .failure(_):
                //FIXME: Message 를 가져오지 못했습니다. Alert
                return
            }
        }
    }
    
    func didTapAddMesssageButton() {
        let message: Message = .init(date: Date(), contents: "Contents...")
        messageStorage.save(message)
        self.messages.append(message)
        self.refreshTrigger.send(.oneRow)
    }
}
