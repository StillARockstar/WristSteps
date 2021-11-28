//
//  DebugMenuViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import Foundation
import Combine

class DebugMenuViewProvider: ObservableObject {
    private let dataProvider: DataProvider

    var files: [String]

    private var subscriptions: Set<AnyCancellable> = Set()

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.files = DataStore.allFileURLs?.map({ $0.lastPathComponent }) ?? []
    }

    func resetApp() {
        DataStore.dumpAllFiles()
        restartApp()
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
