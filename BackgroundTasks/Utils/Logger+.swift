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
}
