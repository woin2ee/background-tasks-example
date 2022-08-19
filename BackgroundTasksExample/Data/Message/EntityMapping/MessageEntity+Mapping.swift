//
//  MessageEntity+Mapping.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import CoreData

extension Message {
    @discardableResult
    func toEntity(in context: NSManagedObjectContext) -> MessageEntity {
        let entity: MessageEntity = .init(context: context)
        entity.date = self.date
        entity.contents = self.contents
        return entity
    }
}

extension MessageEntity {
    func toDomain() -> Message? {
        guard let date = self.date, let contents = self.contents else {
            return nil
        }
        return .init(date: date, contents: contents)
    }
}
