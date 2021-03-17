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

    lazy var setGoalViewProvider = {
        SetGoalViewProvider(
            dataProvider: dataProvider
        )
    }()

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
    }
}
