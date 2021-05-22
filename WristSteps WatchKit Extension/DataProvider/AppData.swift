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

class AppAppData: AppData {
    private(set) var onboardingDone: Bool

    init() {
        self.onboardingDone = DataStore.namespace(DataStoreConstants.namespace).get(key: DataStoreConstants.onboardingDoneKey) as? Bool ?? false
    }

    func setOnboardingDone(_ flag: Bool) {
        self.onboardingDone = flag
        DataStore.namespace(DataStoreConstants.namespace).set(value: flag, for: DataStoreConstants.onboardingDoneKey)
    }

    private struct DataStoreConstants {
        static let namespace = "app_data"
        static let onboardingDoneKey = "onboarding_done"
    }
}
