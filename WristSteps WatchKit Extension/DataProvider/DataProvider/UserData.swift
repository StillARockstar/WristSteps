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
