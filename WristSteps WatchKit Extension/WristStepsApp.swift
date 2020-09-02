//
//  WristStepsApp.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

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

    override init() {
        #if TARGET_WATCH
        self.dataProvider = AppDataProvider()
        #else
        self.dataProvider = SimulatorDataProvider()
        #endif
        super.init()
    }

    func applicationWillEnterForeground() {
        dataProvider.healthData.update()
    }

    func applicationDidEnterBackground() {
        print("Application did enter background")
    }
}
