//
//  ContentViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import Foundation

class ContentViewProvider {
    private let dataProvider: DataProvider
    private let iapManager: IAPManager

    lazy var onboardingProvider = {
        OnboardingViewProvider()
    }()
    lazy var settingsViewProvider = {
        SettingsViewProvider(
            dataProvider: dataProvider,
            iapManager: iapManager
        )
    }()
    lazy var homeViewProvider = {
        HomeViewProvider(
            dataProvider: dataProvider,
            iapManager: iapManager
        )
    }()

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
    }

    func shouldShowOnboardingAndSetFlag() -> Bool {
        if !dataProvider.appData.onboardingDone {
            dataProvider.appData.setOnboardingDone(true)
            return true
        }
        return false
    }
}
