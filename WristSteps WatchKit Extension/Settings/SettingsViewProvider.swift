//
//  SettingsViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import Foundation

class SettingsViewProvider {
    private let dataProvider: DataProvider
    private let iapManager: IAPManager

    var setGoalViewProvider: SetGoalViewProvider {
        SetGoalViewProvider(
            dataProvider: dataProvider
        )
    }
    var setColorViewProvider: SetColorViewProvider {
        SetColorViewProvider(
            dataProvider: dataProvider,
            iapManager: iapManager
        )
    }
    var onboardingProvider: OnboardingViewProvider {
        OnboardingViewProvider(
            showIntroPage: false
        )
    }
    var aboutAppProvider: AboutAppViewProvider {
        AboutAppViewProvider()
    }

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
    }
}
