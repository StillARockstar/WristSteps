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

    var colorName: String { get }
    var colorNamePublished: Published<String> { get }
    var colorNamePublisher: Published<String>.Publisher { get }

    func update(stepGoal: Int)
    func update(colorName: String)
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
    @Published var stepGoal: Int = 10000
    var stepGoalPublished: Published<Int> { _stepGoal }
    var stepGoalPublisher: Published<Int>.Publisher { $stepGoal }

    @Published var colorName: String = AppColor.appBlue.name
    var colorNamePublished: Published<String> { _colorName }
    var colorNamePublisher: Published<String>.Publisher { $colorName}

    init() {
        self.stepGoal = DataStore.namespace(DataStoreConstants.namespace).get(key: DataStoreConstants.stepGoalKey) as? Int ?? 10000
        self.colorName = DataStore.namespace(DataStoreConstants.namespace).get(key: DataStoreConstants.colorKey) as? String ?? AppColor.appBlue.name
    }

    func update(stepGoal: Int) {
        self.stepGoal = stepGoal
        DataStore.namespace(DataStoreConstants.namespace).set(value: stepGoal, for: DataStoreConstants.stepGoalKey)
    }

    func update(colorName: String) {
        self.colorName = colorName
        DataStore.namespace(DataStoreConstants.namespace).set(value: colorName, for: DataStoreConstants.colorKey)
    }

    private struct DataStoreConstants {
        static let namespace = "user_data"
        static let stepGoalKey = "step_goal"
        static let colorKey = "app_color"
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


// - MARK: SampleDataProvider

class SampleDataProvider: DataProvider {
    let healthData: HealthData
    let userData: UserData

    init() {
        self.healthData = SampleHealthData()
        self.userData = SampleUserData()
    }
}

class SampleHealthData: HealthData {
    @Published var stepCount: Int = 5000
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    func update(completion: @escaping ((Bool) -> Void)) { }
}

class SampleUserData: UserData {
    @Published var stepGoal: Int = 10000
    var stepGoalPublished: Published<Int> { _stepGoal }
    var stepGoalPublisher: Published<Int>.Publisher { $stepGoal }

    @Published var colorName: String = AppColor.appBlue.name
    var colorNamePublished: Published<String> { _colorName }
    var colorNamePublisher: Published<String>.Publisher { $colorName}

    init() { }

    func update(stepGoal: Int) { }

    func update(colorName: String) { }
}
