//
//  CoreDataMessageStorage.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import CoreData
import OSLog

final class CoreDataMessageStorage: MessageStorage {
    
    private let coreDataStorage = CoreDataStorage.shared
    
    func save(_ message: Message) {
        message.toEntity(in: coreDataStorage.context)
        coreDataStorage.saveContext()
    }
    
    func getMessages(_ completion: @escaping (Result<[Message], Error>) -> Void) {
        do {
            let messageEntities = try coreDataStorage.context.fetch(MessageEntity.fetchRequest())
            let messages = messageEntities.compactMap { $0.toDomain() }
            completion(.success(messages))
        } catch {
            Logger.coreData.error("CoreData fetch 실패")
            completion(.failure(CoreDataError.readError))
        }
    }
}
