//
//  InfoViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import Foundation

class AboutAppViewProvider: ObservableObject {
    let versionNumber: String
    let copyrightText: String

    init() {
        self.versionNumber = "\(Bundle.main.releaseVersionNumber) (\(Bundle.main.buildVersionNumber))"
        self.copyrightText = "© 2021 Michael Schoder"
    }
}
