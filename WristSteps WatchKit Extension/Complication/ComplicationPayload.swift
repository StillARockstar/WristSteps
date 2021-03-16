//
//  ComplicationPayload.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 02.09.20.
//

import Foundation

enum ComplicationPayloadKey: String {
    case stepCount = "stepCount"
    case stepGoal = "stepGoal"
    case colorName = "colorName"
}

class ComplicationPayload {
    static let shared: ComplicationPayload = {
        ComplicationPayload()
    }()

    private init() { }

    func set(_ key: ComplicationPayloadKey, newValue: Any) {
        DataStore.namespace(DataStoreConstants.namespace).set(value: newValue, for: key.rawValue)
    }

    private struct DataStoreConstants {
        static let namespace = "complication_payload"
    }
}
