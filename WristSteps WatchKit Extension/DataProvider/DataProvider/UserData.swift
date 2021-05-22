//
//  UserData.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 22.05.21.
//

import Foundation

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

struct UserDataDataStoreEntity: DataStoreEntity {
    static let namespace = "user_data"
    var stepGoal: Int
    var colorName: String
}

class AppUserData: UserData {
    @Published var stepGoal: Int = 10000
    var stepGoalPublished: Published<Int> { _stepGoal }
    var stepGoalPublisher: Published<Int>.Publisher { $stepGoal }

    @Published var colorName: String = AppColor.appBlue.name
    var colorNamePublished: Published<String> { _colorName }
    var colorNamePublisher: Published<String>.Publisher { $colorName}

    init() {
        if let persistedData: UserDataDataStoreEntity = DataStore.load() {
            self.stepGoal = persistedData.stepGoal
            self.colorName = persistedData.colorName
        }
    }

    func update(stepGoal: Int) {
        self.stepGoal = stepGoal
        persist()
    }

    func update(colorName: String) {
        self.colorName = colorName
        persist()
    }

    private func persist() {
        let entity = UserDataDataStoreEntity(stepGoal: self.stepGoal, colorName: self.colorName)
        DataStore.persist(entity)
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
        // StepGoal is not loaded for SampleData. For Sample it is always 10k
        if let persistedData: UserDataDataStoreEntity = DataStore.load() {
            self.colorName = persistedData.colorName
        }
    }

    func update(stepGoal: Int) { }

    func update(colorName: String) { }
}
