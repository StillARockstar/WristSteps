//
//  DebugMenuViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import Foundation
import Combine
import CoreAnalytics

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
}

class DebugMenuViewProvider: ObservableObject {
    private var numberOfFiles = 0
    private var currentLoadedFiles = 0
    @Published var loadedLogs: [InsightLogs.InsightMessage] = []
    @Published var moreLogsAvailabe: Bool = false

    init() {
    }

    func loadLogs() {
        numberOfFiles = CoreAnalytics.logs.numberOfFiles()
        guard numberOfFiles > 0 else {
            return
        }
        loadedLogs = CoreAnalytics.logs.loadLog(at: 0)
        currentLoadedFiles = 1
        moreLogsAvailabe = currentLoadedFiles < numberOfFiles
    }

    func loadMoreLogs() {
        guard currentLoadedFiles < numberOfFiles else {
            return
        }
        loadedLogs.append(contentsOf: CoreAnalytics.logs.loadLog(at: currentLoadedFiles))
        currentLoadedFiles += 1
        moreLogsAvailabe = currentLoadedFiles < numberOfFiles
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
            XLog("Failed clearing App")
        }
    }

    private func restartApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            exit(0)
        })
    }
}
