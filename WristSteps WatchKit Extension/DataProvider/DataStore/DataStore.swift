//
//  DataStore.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import Foundation
import CoreInsights

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

    private static func saveJSON(data: Data, withFilename filename: String) {
        guard let rootDirectory = Self.rootDirectory else {
            return
        }
        var fileURL = rootDirectory.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        try? data.write(to: fileURL, options: [.atomicWrite])
        trackInsightFile(fileURL)
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
extension DataStore {
    static var allFileURLs: [URL]? {
        guard let rootDirectory = Self.rootDirectory else {
            return nil
        }
        return try? FileManager.default.contentsOfDirectory(
            at: rootDirectory,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        )
    }

    static func dumpAllFiles() {
        allFileURLs?.forEach({ try? FileManager.default.removeItem(at: $0) })
    }

    static func lastChanged(of url: URL) -> Date? {
        let attr = try? FileManager.default.attributesOfItem(atPath: url.path)
        return attr?[FileAttributeKey.modificationDate] as? Date
    }

    static func contentOf(url: URL) -> String? {
        let filename = url.deletingPathExtension().lastPathComponent
        guard let data = loadJSON(withFilename: filename) else {
            return nil
        }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8)
        else {
            return nil
        }

        return prettyPrintedString
    }
}
