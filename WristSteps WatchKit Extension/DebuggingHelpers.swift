//
//  DebuggingHelpers.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 15.10.21.
//

import Foundation

// Logging

fileprivate var loggingEnabled = false

func setupLogging(dataProvider: DataProvider) {
    loggingEnabled = dataProvider.appData.debuggingEnabled
}

func XLog(_ format: String, _ args: CVarArg...) {
    NSLog(format, args)
}
