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
    let minimumStepGoal: Double = 1000
    let maximumStepGoal: Double = 90000
    @Published var stepGoal: Double = 0

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.stepGoal = Double(dataProvider.userData.stepGoal)
    }

    func commitStepGoalUpdate() {
        guard stepGoal >= minimumStepGoal && stepGoal <= maximumStepGoal else { return }
        self.dataProvider.userData.update(stepGoal: Int(stepGoal))
    }
}
