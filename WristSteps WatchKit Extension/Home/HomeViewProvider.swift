//
//  HomeViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import Foundation
import Combine

class HomeViewProvider: ObservableObject {
    private let dataProvider: DataProvider
    private var subscriptions: Set<AnyCancellable> = Set()

    @Published var stepCount: Int = 0
    @Published var stepGoal: Int = 0
    @Published var hourlySteps: [BarChartBarData] = []

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        dataProvider.healthData.stepCountPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.stepCount, on: self)
            .store(in: &subscriptions)
        dataProvider.healthData.hourlyStepCountsPublisher
            .receive(on: DispatchQueue.main)
            .map({ $0.map({ BarChartBarData(value: Float($0)) }) })
            .assign(to: \.hourlySteps, on: self)
            .store(in: &subscriptions)
        dataProvider.userData.stepGoalPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.stepGoal, on: self)
            .store(in: &subscriptions)
    }
}
