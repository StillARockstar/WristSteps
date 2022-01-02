//
//  InfoViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import Foundation
import Combine

class AboutAppViewProvider: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = Set()
    
    let versionNumber: String
    let copyrightText: String
    let debugConfiguration: Bool

    @Published var debuggingEnabled: Bool

    init(dataProvider: DataProvider) {
        self.versionNumber = "\(Bundle.main.releaseVersionNumber) (\(Bundle.main.buildVersionNumber))"
        self.copyrightText = "© 2022 Michael Schoder"
        self.debugConfiguration = dataProvider.appData.debugConfiguration
        self.debuggingEnabled = dataProvider.appData.debuggingEnabled

        self.$debuggingEnabled
            .dropFirst()
            .sink(receiveValue: { debuggingEnabled in
                dataProvider.appData.setDebuggingEnabled(debuggingEnabled)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    exit(0)
                })
            })
            .store(in: &subscriptions)
    }
}
