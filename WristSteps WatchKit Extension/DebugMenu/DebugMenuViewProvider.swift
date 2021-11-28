//
//  DebugMenuViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import Foundation
import Combine

class DebugMenuViewProvider: ObservableObject {
    private var subscriptions: Set<AnyCancellable> = Set()

    init() {
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

    func lastChanged(of filename: String) -> String {
        guard let url = DataStore.rootDirectory?.appendingPathComponent(filename),
              let date = DataStore.lastChanged(of: url)
        else {
            return ""
        }
        return date.yyyymmddhhmmString
    }

    func content(of filename: String) -> String {
        guard let url = DataStore.rootDirectory?.appendingPathComponent(filename) else {
            return ""
        }
        return DataStore.contentOf(url: url) ?? ""
    }

    private func restartApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            exit(0)
        })
    }
}
