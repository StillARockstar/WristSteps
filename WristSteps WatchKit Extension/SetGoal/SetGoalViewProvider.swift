//
//  SetGoalProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import Foundation

class SetGoalViewProvider: ObservableObject {
    private let dataProvider: DataProvider

    @Published var stepGoal: Int = 0

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.stepGoal = dataProvider.userData.stepGoal
    }
}
