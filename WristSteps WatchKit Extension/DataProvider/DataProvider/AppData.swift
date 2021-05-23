//
//  AppData.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 22.05.21.
//

import Foundation

protocol AppData {
    var debugConfiguration: Bool { get }
    var onboardingDone: Bool { get }
    var debuggingEnabled: Bool { get }

    func setOnboardingDone(_ flag: Bool)
    func setDebuggingEnabled(_ flag: Bool)
}

private struct AppDataDataStoreEntity: DataStoreEntity {
    static let namespace = "app_data"
    var onboardingDone: Bool
    var debuggingEnabled: Bool
}

class AppAppData: AppData {
    var debugConfiguration: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    private(set) var onboardingDone: Bool = false
    private(set) var debuggingEnabled: Bool = false

    init() {
        self.debuggingEnabled = debugConfiguration
        if let persistedData: AppDataDataStoreEntity = DataStore.load() {
            self.onboardingDone = persistedData.onboardingDone
            if !debugConfiguration {
                self.debuggingEnabled = persistedData.debuggingEnabled
            }
        }
    }

    func setOnboardingDone(_ flag: Bool) {
        self.onboardingDone = flag
        persist()
    }

    func setDebuggingEnabled(_ flag: Bool) {
        guard !self.debugConfiguration else {
            return
        }

        self.debuggingEnabled = flag
        persist()
    }

    private func persist() {
        let entity = AppDataDataStoreEntity(
            onboardingDone: self.onboardingDone,
            debuggingEnabled: self.debuggingEnabled
        )
        DataStore.persist(entity)
    }
}
