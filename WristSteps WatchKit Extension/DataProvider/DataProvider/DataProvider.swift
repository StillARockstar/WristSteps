//
//  DataProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import Foundation

protocol DataProvider {
    var appData: AppData { get }
    var healthData: HealthData { get }
    var userData: UserData { get }
}

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
