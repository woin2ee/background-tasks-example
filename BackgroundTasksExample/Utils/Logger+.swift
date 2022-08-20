//
//  Logger+.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import OSLog

extension Logger {
    static let subsystem = Bundle.main.bundleIdentifier!
    
    static let test = Logger.init(subsystem: subsystem, category: "Test")
    static let coreData = Logger.init(subsystem: subsystem, category: "CoreData")
    static let appState = Logger.init(subsystem: subsystem, category: "AppState")
    static let backgroundTasks = Logger.init(subsystem: subsystem, category: "BackgroundTasks")
}
