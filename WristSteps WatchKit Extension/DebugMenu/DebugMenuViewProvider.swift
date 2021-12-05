//
//  DebugMenuViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import Foundation
import Combine
import CoreAnalytics

extension InsightLevel {
    var formatted: String {
        switch self {
        case .`default`:
            return "default"
        case .error:
            return "error"
        case .warning:
            return "warning"
        case .info:
            return "info"
        case .debug:
            return "debug"
        }
    }
}

extension InsightLogs.InsightMessage {
    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: date) + msg
    }

    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }

    var formattedLevel: String {
        return level.formatted
    }

    var formattedTags: String {
        return tags.joined(separator: ", ")
    }
}

class DebugMenuViewProvider: ObservableObject {
    private var numberOfFiles = 0
    private var currentLoadedFiles = 0
    private var loadedLogs: [InsightLogs.InsightMessage] = []
    private(set) var shownLevels: [InsightLevel] = [.default, .error, .warning, .info, .debug]
    private(set) var shownTags: [String]? = nil
    @Published var filteredLogs: [InsightLogs.InsightMessage] = []
    @Published var moreLogsAvailabe: Bool = false

    init() {
    }

    func loadLogs() {
        numberOfFiles = CoreAnalytics.logs.numberOfFiles()
        guard numberOfFiles > 0 else {
            return
        }
        loadedLogs = CoreAnalytics.logs.loadLog(at: 0)
        filteredLogs = loadedLogs
            .filterBy(levels: shownLevels)
            .filterBy(tags: shownTags)
        currentLoadedFiles = 1
        moreLogsAvailabe = currentLoadedFiles < numberOfFiles
    }

    func loadMoreLogs() {
        guard currentLoadedFiles < numberOfFiles else {
            return
        }
        loadedLogs.append(contentsOf: CoreAnalytics.logs.loadLog(at: currentLoadedFiles))
        filteredLogs = loadedLogs
            .filterBy(levels: shownLevels)
            .filterBy(tags: shownTags)
        currentLoadedFiles += 1
        moreLogsAvailabe = currentLoadedFiles < numberOfFiles
    }

    func availableLogLevels() -> [InsightLevel] {
        return [.default, .error, .warning, .info, .debug]
    }

    func toggleLogFilter(_ level: InsightLevel) {
        if !shownLevels.contains(level) {
            shownLevels.append(level)
        } else {
            shownLevels.removeAll(where: { $0 == level })
        }
        filteredLogs = loadedLogs
            .filterBy(levels: shownLevels)
            .filterBy(tags: shownTags)
    }

    func availableTags() -> [String] {
        let allTags = loadedLogs.map({ $0.tags }).flatMap({ $0 })
        return allTags.removeDuplicates()
    }

    func toggleTagFilter(_ tag: String) {
        var shownTags = shownTags ?? []
        if !shownTags.contains(tag) {
            shownTags.append(tag)
        } else {
            shownTags.removeAll(where: { $0 == tag })
        }
        if shownTags.count == 0 {
            self.shownTags = nil
        } else {
            self.shownTags = shownTags
        }
        filteredLogs = loadedLogs
            .filterBy(levels: shownLevels)
            .filterBy(tags: self.shownTags)
    }

    func resetApp() {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first else { return }
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentDirectory.path)
            for filePath in filePaths {
                try fileManager.removeItem(
                    atPath: documentDirectory.appendingPathComponent(filePath).path
                )
            }
            restartApp()
        } catch {
            print("Failed Resetting App")
        }
    }

    private func restartApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            exit(0)
        })
    }
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

public extension Array where Element == InsightLogs.InsightMessage {
    func filterBy(tags tagStrings: [String]?) -> [Element] {
        guard let tagStrings = tagStrings else {
            return self
        }
        var results = self
        for tagString in tagStrings {
            results = results.filterBy(tag: tagString)
        }
        return results
    }
}
