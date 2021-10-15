//
//  HealthData.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 22.05.21.
//

import Foundation
import Combine
import CoreMotion
import HealthKit

protocol HealthData {
    var stepCount: Int { get }
    var stepCountPublished: Published<Int> { get }
    var stepCountPublisher: Published<Int>.Publisher { get }

    var hourlyStepCounts: [Int?] { get }
    var hourlyStepCountsPublished: Published<[Int?]> { get }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { get }

    func registerHealthKitUpdates()

    func updateBulk(completion: @escaping (() -> Void))
    func updateHour(hour: Int, completion: @escaping (() -> Void))
    func loadPersistedStepCounts()
    func clearHourlyStepCounts()
}

private struct HealthDataDataStoreEntity: DataStoreEntity {
    static let namespace = "health_data"
    var hourlyStepCounts: [Int?]
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
    private let healthStore = HKHealthStore()

    init() {
        clearHourlyStepCounts()
        self.$hourlyStepCounts.sink(receiveValue: { hourlyStepCounts in
            self.stepCount = hourlyStepCounts.compactMap({$0}).reduce(0, +)
        })
        .store(in: &subscriptions)
    }

    func registerHealthKitUpdates() {
        let allTypes = Set([HKObjectType.workoutType()])
        healthStore.requestAuthorization(toShare: allTypes, read: nil, completion: { success, _ in
            if success {

            }
        })
    }

    func updateBulk(completion: @escaping (() -> Void)) {
        var completedUpdates = 0
        var hourlyStepCountsCache = [Int?]()
        for i in 0..<self.hourlyStepCounts.count {
            loadHour(hour: i, completion: { [weak self] hourlyStepCount in
                completedUpdates += 1
                hourlyStepCountsCache.append(hourlyStepCount)
                if completedUpdates == self?.hourlyStepCounts.count ?? 0 - 1 {
                    self?.hourlyStepCounts = hourlyStepCountsCache
                    self?.persist()
                    completion()
                }
            })
        }
    }

    func updateHour(hour: Int, completion: @escaping (() -> Void)) {
        loadHour(hour: hour, completion: { [weak self] hourlyStepCount in
            self?.hourlyStepCounts[hour] = hourlyStepCount
            self?.persist()
            completion()
        })
    }

    func loadPersistedStepCounts() {
        if let persistedData: HealthDataDataStoreEntity = DataStore.load() {
            self.hourlyStepCounts = persistedData.hourlyStepCounts
        }
    }

    func clearHourlyStepCounts() {
        for i in 0..<self.hourlyStepCounts.count {
            self.hourlyStepCounts[i] = nil
        }
    }

    private func persist() {
        let entity = HealthDataDataStoreEntity(hourlyStepCounts: self.hourlyStepCounts)
        DataStore.persist(entity)
    }

    private func loadHour(hour: Int, completion: @escaping ((Int?) -> Void)) {
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

        pedometer.queryPedometerData(
            from: startDate,
            to: endDate,
            withHandler: { pedometerData, error in
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

    func registerHealthKitUpdates() {
    }

    func updateBulk(completion: @escaping (() -> Void)) {
        DispatchQueue(label: "simulated_data").asyncAfter(
            deadline: .now() + 0.1,
            execute: { [weak self] in
                var hourlyStepCountsCache = [Int?]()
                for i in 0..<24 {
                    if i <= 12 {
                        hourlyStepCountsCache.append(Int.random(in: 0...1000))
                    } else {
                        hourlyStepCountsCache.append(nil)
                    }
                }
                self?.hourlyStepCounts = hourlyStepCountsCache
                self?.persist()
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
                self?.persist()
                completion()
        })
    }

    func loadPersistedStepCounts() {
        if let persistedData: HealthDataDataStoreEntity = DataStore.load() {
            self.hourlyStepCounts = persistedData.hourlyStepCounts
        }
    }

    func clearHourlyStepCounts() {
        for i in 0..<self.hourlyStepCounts.count {
            self.hourlyStepCounts[i] = nil
        }
    }

    private func persist() {
        let entity = HealthDataDataStoreEntity(hourlyStepCounts: self.hourlyStepCounts)
        DataStore.persist(entity)
    }
}

class SampleHealthData: HealthData {
    @Published var stepCount: Int = 5000
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }

    @Published var hourlyStepCounts: [Int?] = [75, 0, 0, 0, 0, 0, 100, 500, 1100, 700, 400, 350, 600, 650, 470, 400, 600, 900, 930, 700, 600, 400, 300, 200]
    var hourlyStepCountsPublished: Published<[Int?]> { _hourlyStepCounts }
    var hourlyStepCountsPublisher: Published<[Int?]>.Publisher { $hourlyStepCounts }

    func registerHealthKitUpdates() {
    }

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
