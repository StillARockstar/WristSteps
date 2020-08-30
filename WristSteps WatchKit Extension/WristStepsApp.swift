//
//  WristStepsApp.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

@main
struct WristStepsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                #if TARGET_WATCH
                HomeView()
                    .environmentObject(
                        HomeViewProvider(dataProvider: AppDataProvider())
                    )
                #else
                HomeView()
                    .environmentObject(
                        HomeViewProvider(dataProvider: SimulatorDataProvider())
                    )
                #endif
            }
        }
    }
}
