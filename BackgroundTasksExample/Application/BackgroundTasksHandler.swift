//
//  BackgroundTasksHandler.swift
//  BackgroundTasksExample
//
//  Created by Jaewon on 2022/08/19.
//

import Foundation
import BackgroundTasks
import OSLog

private enum BGSchdulerID {
    static let appRefresh = "com.refresh"
}

final class BackgroundTasksHandler {
    
    static let shared = BackgroundTasksHandler.init()
    
    private var messageStorage: MessageStorage = CoreDataMessageStorage.init()
    
    private init() {}
    
    func launchAppRefreshIfRequested(using queue: DispatchQueue?) {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BGSchdulerID.appRefresh,
            using: nil,
            launchHandler: { task in
                BackgroundTasksHandler.shared.handleAppRefresh(task: task as! BGAppRefreshTask)
            }
        )
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        self.scheduleAppRefresh()
        
        task.expirationHandler = {
            Logger.backgroundTasks.notice("Background Tasks 만료됨.")
        }
        
        let message: Message = .init(date: Date(), contents: "Background...")
        self.messageStorage.save(message)
        task.setTaskCompleted(success: true)
        
        Logger.backgroundTasks.notice("Background 에서 최근 메세지 가져오기 성공.")
    }
    
    func scheduleAppRefresh() {
        let request: BGAppRefreshTaskRequest = .init(identifier: BGSchdulerID.appRefresh)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            Logger.backgroundTasks.notice("BGTaskScheduler 에 App refresh 작업 등록 성공.")
        } catch {
            let nserror = error as NSError
            Logger.backgroundTasks.error("Could not schedule app refresh. \(nserror), \(nserror.userInfo)")
        }
    }
}
