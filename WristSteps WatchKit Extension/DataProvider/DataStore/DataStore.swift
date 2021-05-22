//
//  DataStore.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import Foundation

protocol DataStoreEntity: Codable {
    static var namespace: String { get }
}

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

extension DataStore {
    static func persist<T : DataStoreEntity>(_ entitiy: T) {
        guard let jsonData = try? JSONEncoder().encode(entitiy) else {
            return
        }
        self.saveJSON(data: jsonData, withFilename: T.namespace)
    }

    static func load<T: DataStoreEntity>() -> T? {
        guard let jsonData = self.loadJSON(withFilename: T.namespace) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: jsonData)
    }

    private static func saveJSON(data: Data, withFilename filename: String) {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            return
        }
        var fileURL = url.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        try? data.write(to: fileURL, options: [.atomicWrite])
    }

    private static func loadJSON(withFilename filename: String) -> Data? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            return nil
        }
        var fileURL = url.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        return try? Data(contentsOf: fileURL)
    }
}
