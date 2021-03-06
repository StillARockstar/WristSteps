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
    var lastBackgroundUpdate: String { get }

    func setOnboardingDone(_ flag: Bool)
    func setDebuggingEnabled(_ flag: Bool)
    func setLastBackgroundUpdate(_ string: String)
}

private struct AppDataDataStoreEntity: DataStoreEntity {
    static let namespace = "app_data"
    var onboardingDone: Bool
    var debuggingEnabled: Bool
    var lastBackgroundUpdate: String
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
    private(set) var lastBackgroundUpdate: String = ""

    init() {
        self.debuggingEnabled = debugConfiguration
        if let persistedData: AppDataDataStoreEntity = DataStore.load() {
            self.onboardingDone = persistedData.onboardingDone
            self.lastBackgroundUpdate = persistedData.lastBackgroundUpdate
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

    func setLastBackgroundUpdate(_ string: String) {
        self.lastBackgroundUpdate = string
        persist()
    }

    private func persist() {
        let entity = AppDataDataStoreEntity(
            onboardingDone: self.onboardingDone,
            debuggingEnabled: self.debuggingEnabled,
            lastBackgroundUpdate: self.lastBackgroundUpdate
        )
        DataStore.persist(entity)
    }
}
