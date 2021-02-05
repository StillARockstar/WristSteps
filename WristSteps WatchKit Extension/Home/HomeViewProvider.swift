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
    private let iapManager: IAPManager
    private var subscriptions: Set<AnyCancellable> = Set()

    var onboardingProvider: OnboardingViewProvider { OnboardingViewProvider() }
    var setGoalViewProvider: SetGoalViewProvider { SetGoalViewProvider(dataProvider: dataProvider) }
    var setColorViewProvider: SetColorViewProvider { SetColorViewProvider(dataProvider: dataProvider, iapManager: iapManager) }
    var infoViewProvider: InfoViewProvider { InfoViewProvider(dataProvider: dataProvider)}

    @Published var stepCount: Int = 0
    @Published var stepGoal: Int = 0

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
        dataProvider.healthData.stepCountPublisher.receive(on: DispatchQueue.main).assign(to: \.stepCount, on: self).store(in: &subscriptions)
        dataProvider.userData.stepGoalPublisher.receive(on: DispatchQueue.main).assign(to: \.stepGoal, on: self).store(in: &subscriptions)
    }

    func shouldShowOnboardingAndSetFlag() -> Bool {
        if !dataProvider.appData.onboardingDone {
            dataProvider.appData.setOnboardingDone(true)
            return true
        }
        return false
    }
}
