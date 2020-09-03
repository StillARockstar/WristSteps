//
//  DataProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import Foundation
import CoreMotion

protocol DataProvider {
    var healthData: HealthData { get }
    var userData: UserData { get }
}

protocol HealthData {
    var stepCount: Int { get }
    var stepCountPublished: Published<Int> { get }
    var stepCountPublisher: Published<Int>.Publisher { get }

    func update(completion: @escaping ((Bool) -> Void))
}

protocol UserData {
    var stepGoal: Int { get }
    var stepGoalPublished: Published<Int> { get }
    var stepGoalPublisher: Published<Int>.Publisher { get }

    func update(stepGoal: Int)
}



// - MARK: App Data Provider

class AppDataProvider: DataProvider {
    let healthData: HealthData
    let userData: UserData

    init() {
        self.healthData = AppHealthData()
        self.userData = AppUserData()
    }
}

class AppHealthData: HealthData {
    @Published var stepCount: Int = 0
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    private let pedometer = CMPedometer()

    func update(completion: @escaping ((Bool) -> Void)) {
        let endDate = Date()
        let startDate = Calendar.current.startOfDay(for: endDate)

        pedometer.queryPedometerData(from: startDate, to: endDate, withHandler: { [weak self] pedometerData, error in
            guard let pedometerData = pedometerData else {
                completion(false)
                return
            }
            self?.stepCount = pedometerData.numberOfSteps.intValue
            completion(true)
        })
    }
}

class AppUserData: UserData {
    @Published var stepGoal: Int = 0
    var stepGoalPublished: Published<Int> { _stepGoal }
    var stepGoalPublisher: Published<Int>.Publisher { $stepGoal }

    func update(stepGoal: Int) {
        self.stepGoal = stepGoal
    }
}



// - MARK: Simulator Data Provider

class SimulatorDataProvider: DataProvider {
    let healthData: HealthData
    let userData: UserData

    init() {
        self.healthData = SimulatorHealthData()
        self.userData = AppUserData()
    }
}

class SimulatorHealthData: HealthData {
    @Published var stepCount: Int = 0
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    func update(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue(label: "simulated_data").asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.stepCount = Int.random(in: 0...10000)
            completion(true)
        }
    }
}
