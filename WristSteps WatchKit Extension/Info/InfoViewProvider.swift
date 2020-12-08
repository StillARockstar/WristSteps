//
//  InfoViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import Foundation

class InfoViewProvider: ObservableObject {
    private let dataProvider: DataProvider
    let versionNumber: String

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.versionNumber = "1.0.1 (2)"
    }
}
