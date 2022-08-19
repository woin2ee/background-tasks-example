//
//  MessageStorage.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import Foundation

protocol MessageStorage {
    func save(_ message: Message)
    func getMessages(_ completion: @escaping (Result<[Message], Error>) -> Void)
}
