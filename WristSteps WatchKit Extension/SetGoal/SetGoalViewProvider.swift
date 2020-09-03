//
//  SetGoalProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import Foundation

class SetGoalViewProvider: ObservableObject {
    private let dataProvider: DataProvider

    let recommendedStepGoal = 10000
    let minimumStepGoal = 1000
    let maximumStepGoal = 90000
    @Published var stepGoal: Int = 0

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.stepGoal = dataProvider.userData.stepGoal
    }

    func commitStepGoalUpdate() {
        guard stepGoal >= minimumStepGoal && stepGoal <= maximumStepGoal else { return }
        self.dataProvider.userData.update(stepGoal: stepGoal)
    }
}
