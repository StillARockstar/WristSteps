//
//  HealthData.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 22.05.21.
//

import Foundation
import Combine
import CoreMotion

protocol HealthData {
    var stepCount: Int { get }
    var stepCountPublished: Published<Int> { get }
    var stepCountPublisher: Published<Int>.Publisher { get }

    var hourlyStepCounts: [Int?] { get }
    var hourlyStepCountsPublished: Published<[Int?]> { get }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { get }

    func updateBulk(completion: @escaping (() -> Void))
    func updateHour(hour: Int, completion: @escaping (() -> Void))
    func loadPersistedStepCounts()
    func clearHourlyStepCounts()
}

class AppHealthData: HealthData {
    @Published var stepCount: Int = 0
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = [Int?](repeating: nil, count: 24)
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

    private var subscriptions: Set<AnyCancellable> = Set()
    private let pedometer = CMPedometer()

    init() {
        clearHourlyStepCounts()
        self.$hourlyStepCounts.sink(receiveValue: { hourlyStepCounts in
            self.stepCount = hourlyStepCounts.compactMap({$0}).reduce(0, +)
        })
        .store(in: &subscriptions)
    }

    func updateBulk(completion: @escaping (() -> Void)) {
        var completedUpdates = 0
        for i in 0..<self.hourlyStepCounts.count {
            updateHour(hour: i, completion: { [weak self] in
                completedUpdates += 1
                if completedUpdates == self?.hourlyStepCounts.count ?? 0 - 1 {
                    completion()
                }
            })
        }
    }

    func updateHour(hour: Int, completion: @escaping (() -> Void)) {
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
            self.hourlyStepCounts[hour] = nil
            completion()
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

        pedometer.queryPedometerData(
            from: startDate,
            to: endDate,
            withHandler: { [weak self] pedometerData, error in
                guard let pedometerData = pedometerData else {
                    self?.hourlyStepCounts[hour] = nil
                    completion()
                    return
                }
                self?.hourlyStepCounts[hour] = pedometerData.numberOfSteps.intValue
                completion()
        })
    }

    func loadPersistedStepCounts() {

    }

    func clearHourlyStepCounts() {
        for i in 0..<self.hourlyStepCounts.count {
            self.hourlyStepCounts[i] = nil
        }
    }
}

class SimulatorHealthData: HealthData {
    @Published var stepCount: Int = 0
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = [Int?](repeating: nil, count: 24)
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

    private var subscriptions: Set<AnyCancellable> = Set()

    init() {
        clearHourlyStepCounts()
        self.$hourlyStepCounts.sink(receiveValue: { hourlyStepCounts in
            self.stepCount = hourlyStepCounts.compactMap({$0}).reduce(0, +)
        })
        .store(in: &subscriptions)
    }

    func updateBulk(completion: @escaping (() -> Void)) {
        DispatchQueue(label: "simulated_data").asyncAfter(
            deadline: .now() + 0.1,
            execute: { [weak self] in
                for i in 0..<24 {
                    if i <= 12 {
                        self?.hourlyStepCounts[i] = Int.random(in: 0...1000)
                    } else {
                        self?.hourlyStepCounts[i] = nil
                    }
                }
                completion()
        })
    }

    func updateHour(hour: Int, completion: @escaping (() -> Void)) {
        DispatchQueue(label: "simulated_data").asyncAfter(
            deadline: .now() + 0.1,
            execute: { [weak self] in
                if hour <= 12 {
                    self?.hourlyStepCounts[hour] = Int.random(in: 0...1000)
                } else {
                    self?.hourlyStepCounts[hour] = nil
                }
                completion()
        })
    }

    func loadPersistedStepCounts() {

    }

    func clearHourlyStepCounts() {
        for i in 0..<self.hourlyStepCounts.count {
            self.hourlyStepCounts[i] = nil
        }
    }
}

class SampleHealthData: HealthData {
    @Published var stepCount: Int = 5000
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = [Int?](repeating: nil, count: 24)
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

    func updateBulk(completion: @escaping (() -> Void)) {
        completion()
    }

    func updateHour(hour: Int, completion: @escaping (() -> Void)) {
        completion()
    }

    func loadPersistedStepCounts() {
    }

    func clearHourlyStepCounts() {
    }
}
