//
//  WristStepsApp.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI
import Combine

@main
struct WristStepsApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(
                    HomeViewProvider(dataProvider: extensionDelegate.dataProvider)
                )
                .embedInNavigation()
        }
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    let dataProvider: DataProvider
    private var stepCountPublisher: AnyCancellable

    override init() {
        #if TARGET_WATCH
        self.dataProvider = AppDataProvider()
        #else
        self.dataProvider = SimulatorDataProvider()
        #endif

        self.stepCountPublisher = dataProvider.healthData.stepCountPublisher
            .removeDuplicates()
            .sink { newValue in
                print("New step count: \(newValue)")
            }

        super.init()
    }

    func applicationWillEnterForeground() {
        dataProvider.healthData.update(completion: { _ in })
    }

    func applicationDidEnterBackground() {
        print("Application did enter background")
    }
}
