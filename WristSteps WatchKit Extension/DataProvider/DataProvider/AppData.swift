//
//  AppData.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 22.05.21.
//

import Foundation

protocol AppData {
    var onboardingDone: Bool { get }

    func setOnboardingDone(_ flag: Bool)
}

private struct AppDataDataStoreEntity: DataStoreEntity {
    static let namespace = "app_data"
    var onboardingDone: Bool
}

class AppAppData: AppData {
    private(set) var onboardingDone: Bool = false

    init() {
        if let persistedData: AppDataDataStoreEntity = DataStore.load() {
            self.onboardingDone = persistedData.onboardingDone
        }
    }

    func setOnboardingDone(_ flag: Bool) {
        self.onboardingDone = flag
        persist()
    }

    private func persist() {
        let entity = AppDataDataStoreEntity(onboardingDone: self.onboardingDone)
        DataStore.persist(entity)
    }
}
