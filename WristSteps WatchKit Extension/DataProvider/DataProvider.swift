//
//  DataProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import Foundation
import CoreMotion

protocol DataProvider {
    var appData: AppData { get }
    var healthData: HealthData { get }
    var userData: UserData { get }
}

protocol AppData {
    var onboardingDone: Bool { get }

    func setOnboardingDone(_ flag: Bool)
}

protocol HealthData {
    var stepCount: Int { get }
    var stepCountPublished: Published<Int> { get }
    var stepCountPublisher: Published<Int>.Publisher { get }

    var hourlyStepCounts: [Int?] { get }
    var hourlyStepCountsPublished: Published<[Int?]> { get }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { get }

    func update(completion: @escaping ((Bool) -> Void))
    func updateHourly(completion: @escaping ((Bool) -> Void))
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
    let appData: AppData
    let healthData: HealthData
    let userData: UserData

    init() {
        self.appData = AppAppData()
        self.healthData = AppHealthData()
        self.userData = AppUserData()
    }
}

class AppAppData: AppData {
    private(set) var onboardingDone: Bool

    init() {
        self.onboardingDone = DataStore.namespace(DataStoreConstants.namespace).get(key: DataStoreConstants.onboardingDoneKey) as? Bool ?? false
    }

    func setOnboardingDone(_ flag: Bool) {
        self.onboardingDone = flag
        DataStore.namespace(DataStoreConstants.namespace).set(value: flag, for: DataStoreConstants.onboardingDoneKey)
    }

    private struct DataStoreConstants {
        static let namespace = "app_data"
        static let onboardingDoneKey = "onboarding_done"
    }
}

class AppHealthData: HealthData {
    @Published var stepCount: Int = 0
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = []
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

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

    func updateHourly(completion: @escaping ((Bool) -> Void)) {
        let taskGroup = DispatchGroup()
        var temporarySteps: [Int: Int?] = [:]

        for hour in 0..<24 {
            taskGroup.enter()
            self.steps(for: hour, completion: { steps in
                temporarySteps[hour] = steps
                taskGroup.leave()
            })
        }

        taskGroup.notify(queue: .main, execute: { [weak self] in
            let sortedKeys = Array(temporarySteps.keys).sorted()
            var sortedSteps = [Int?]()
            for key in sortedKeys {
                sortedSteps.append(temporarySteps[key] ?? nil)
            }
            self?.hourlyStepCounts = sortedSteps
            completion(true)
        })
    }

    private func steps(for hour: Int, completion: @escaping (Int?) -> Void) {
        let calendar = Calendar(identifier: .gregorian)
        let nowDate = Date()
        let nowDateComponent = calendar.dateComponents([.year, .month, .day], from: nowDate)

        var startDateComponents = DateComponents()
        startDateComponents.year = nowDateComponent.year
        startDateComponents.month = nowDateComponent.month
        startDateComponents.day = nowDateComponent.day
        startDateComponents.hour = hour
        startDateComponents.minute = 0
        startDateComponents.second = 0
        let startDate = calendar.date(from: startDateComponents) ?? nowDate
        if startDate > nowDate {
            completion(nil)
            return
        }

        var endDateComponents = DateComponents()
        endDateComponents.year = nowDateComponent.year
        endDateComponents.month = nowDateComponent.month
        endDateComponents.day = nowDateComponent.day
        endDateComponents.hour = hour
        endDateComponents.minute = 59
        endDateComponents.second = 59
        let endDate: Date
        if calendar.date(from: endDateComponents) ?? nowDate < nowDate {
            endDate = calendar.date(from: endDateComponents) ?? nowDate
        } else {
            endDate = nowDate
        }

        pedometer.queryPedometerData(from: startDate, to: endDate, withHandler: { pedometerData, error in
            guard let pedometerData = pedometerData else {
                completion(nil)
                return
            }
            completion(pedometerData.numberOfSteps.intValue)
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
    let appData: AppData
    let healthData: HealthData
    let userData: UserData

    init() {
        self.appData = AppAppData()
        self.healthData = SimulatorHealthData()
        self.userData = AppUserData()
    }
}

class SimulatorHealthData: HealthData {
    @Published var stepCount: Int = 0
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = []
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

    func update(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue(label: "simulated_data").asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.stepCount = Int.random(in: 0...10000)
            completion(true)
        }
    }

    func updateHourly(completion: @escaping ((Bool) -> Void)) {
        DispatchQueue(label: "simulated_data").asyncAfter(deadline: .now() + 0.2) { [weak self] in
            var hourlySteps = [Int?]()
            for _ in 0..<12 {
                hourlySteps.append(Int.random(in: 0...1000))
            }
            for _ in 0..<12 {
                hourlySteps.append(nil)
            }
            self?.hourlyStepCounts = hourlySteps
            completion(true)
        }
    }
}


// - MARK: SampleDataProvider

class SampleDataProvider: DataProvider {
    let appData: AppData
    let healthData: HealthData
    let userData: UserData

    init() {
        self.appData = AppAppData()
        self.healthData = SampleHealthData()
        self.userData = SampleUserData()
    }
}

class SampleHealthData: HealthData {
    @Published var stepCount: Int = 5000
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = []
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

    func update(completion: @escaping ((Bool) -> Void)) {
        completion(true)
    }

    func updateHourly(completion: @escaping ((Bool) -> Void)) {
        completion(true)
    }
}

class SampleUserData: UserData {
    @Published var stepGoal: Int = 10000
    var stepGoalPublished: Published<Int> { _stepGoal }
    var stepGoalPublisher: Published<Int>.Publisher { $stepGoal }

    @Published var colorName: String = AppColor.appBlue.name
    var colorNamePublished: Published<String> { _colorName }
    var colorNamePublisher: Published<String>.Publisher { $colorName}

    init() {
        self.colorName = DataStore.namespace(DataStoreConstants.namespace).get(key: DataStoreConstants.colorKey) as? String ?? AppColor.appBlue.name
    }

    func update(stepGoal: Int) { }

    func update(colorName: String) { }

    private struct DataStoreConstants {
        static let namespace = "user_data"
        static let colorKey = "app_color"
    }
}
