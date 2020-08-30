//
//  HomeViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import Foundation

class HomeViewProvider: ObservableObject {
    @Published var stepCount: Int = 0
    @Published var stepGoal: Int = 0

    init(dataProvider: DataProvider) {
        dataProvider.healthData.stepCountPublisher.assign(to: &$stepCount)
        dataProvider.userData.stepGoalPublisher.assign(to: &$stepGoal)
    }
}
