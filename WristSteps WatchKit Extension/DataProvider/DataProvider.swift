//
//  DataProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import Foundation

protocol DataProvider {
    var healthData: HealthData { get }
    var userData: UserData { get }
}

protocol HealthData {
    var stepCount: Int { get }
    var stepCountPublished: Published<Int> { get }
    var stepCountPublisher: Published<Int>.Publisher { get }
}

protocol UserData {
    var stepGoal: Int { get }
    var stepGoalPublished: Published<Int> { get }
    var stepGoalPublisher: Published<Int>.Publisher { get }
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
}

class AppUserData: UserData {
    @Published var stepGoal: Int = 0
    var stepGoalPublished: Published<Int> { _stepGoal }
    var stepGoalPublisher: Published<Int>.Publisher { $stepGoal }
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
    @Published var stepCount: Int = Int.random(in: 0...10000)
    var stepCountPublished: Published<Int> { _stepCount }
    var stepCountPublisher: Published<Int>.Publisher { $stepCount }
}
