//
//  ComplicationPayload.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 02.09.20.
//

import Foundation

enum ComplicationPayloadKey: String {
    case stepCount = "stepCount"
}

class ComplicationPayload {
    static let shared: ComplicationPayload = {
        ComplicationPayload()
    }()

    private let userDefaultsPrefix = "complication_payload"

    private init() { }

    func set(_ key: ComplicationPayloadKey, newValue: Any) {
        let fullKey = "\(userDefaultsPrefix)_\(key.rawValue)"
        UserDefaults.standard.setValue(newValue, forKey: fullKey)
    }
}
