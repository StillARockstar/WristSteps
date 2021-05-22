//
//  HealthData.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 22.05.21.
//

import Foundation
import CoreMotion

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
