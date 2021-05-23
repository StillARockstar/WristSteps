//
//  InfoViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import Foundation
import Combine

class AboutAppViewProvider: ObservableObject {
    let versionNumber: String
    let copyrightText: String
    let debugConfiguration: Bool

    @Published var debuggingEnabled: Bool

    init() {
        self.versionNumber = "\(Bundle.main.releaseVersionNumber) (\(Bundle.main.buildVersionNumber))"
        self.copyrightText = "© 2021 Michael Schoder"
        self.debuggingEnabled = false
        #if DEBUG
        self.debugConfiguration = true
        #else
        self.debugConfiguration = false
        #endif
    }
}
