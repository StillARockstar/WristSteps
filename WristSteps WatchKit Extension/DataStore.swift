//
//  DataStore.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import Foundation

final class DataStore {
    private let namespace: String

    private init(namespace: String) {
        self.namespace = namespace
    }

    static func namespace(_ namespace: String) -> DataStore {
        return DataStore(namespace: namespace)
    }

    func set(value: Any, for key: String) {
        UserDefaults.standard.setValue(value, forKey: "\(namespace)_\(key)")
    }

    func get(key: String) -> Any? {
        UserDefaults.standard.value(forKey: "\(namespace)_\(key)")
    }
}
