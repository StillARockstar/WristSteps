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
    static var rootDirectory: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }

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

    static func dumpAllFiles() {
        guard let rootDirectory = Self.rootDirectory else {
            return
        }
        guard let fileUrls = try? FileManager.default.contentsOfDirectory(
            at: rootDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            return
        }
        fileUrls.forEach({ try? FileManager.default.removeItem(at: $0) })
    }

    private static func saveJSON(data: Data, withFilename filename: String) {
        guard let rootDirectory = Self.rootDirectory else {
            return
        }
        var fileURL = rootDirectory.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        try? data.write(to: fileURL, options: [.atomicWrite])
    }

    private static func loadJSON(withFilename filename: String) -> Data? {
        guard let rootDirectory = Self.rootDirectory else {
            return nil
        }
        var fileURL = rootDirectory.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        return try? Data(contentsOf: fileURL)
    }
}
