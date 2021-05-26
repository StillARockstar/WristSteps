//
//  WristStepsApp.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import ClockKit
import SwiftUI
import Combine

@main
struct WristStepsApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var extensionDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(
                provider: ContentViewProvider(
                    dataProvider: extensionDelegate.dataProvider,
                    iapManager: extensionDelegate.iapManager
                )
            )
        }
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate {
    @Environment(\.appTint) var appTintColor: Color
    let dataProvider: DataProvider
    let iapManager: IAPManager
    private let lifeCycleHandler: LifeCycleHandler
    private let stepCountPublisher: AnyCancellable
    private let stepGoalPublisher: AnyCancellable
    private let colorNamePublisher: AnyCancellable

    override init() {
        #if TARGET_WATCH
        let dataProvider = AppDataProvider()
        #else
        let dataProvider = SimulatorDataProvider()
        #endif
        self.dataProvider = dataProvider

        if dataProvider.appData.debuggingEnabled {
            NSLog("Root URL: \(DataStore.rootDirectory?.absoluteString ?? "")")
        }

        self.iapManager = IAPManager()
        self.iapManager.generateProducts(with: ProductIds.allCases.map({ $0.rawValue }))

        self.lifeCycleHandler = LifeCycleHandler(dataProvider: self.dataProvider)

        self.stepCountPublisher = dataProvider.healthData.stepCountPublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                if dataProvider.appData.debuggingEnabled {
                    NSLog("New step count: \(newValue)")
                }
            }
        self.stepGoalPublisher = dataProvider.userData.stepGoalPublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                if dataProvider.appData.debuggingEnabled == true {
                    NSLog("New step goal: \(newValue)")
                }
            }
        self.colorNamePublisher = dataProvider.userData.colorNamePublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
                Color.update(appTint: AppColor.color(forName: newValue).color)
                if dataProvider.appData.debuggingEnabled == true {
                    NSLog("New color name: \(newValue)")
                }
            }

        super.init()
    }

    func applicationDidFinishLaunching() {
        lifeCycleHandler.applicationDidFinishLaunching()
    }

    func applicationWillEnterForeground() {
        lifeCycleHandler.appWillEnterForeground()
    }

    func applicationDidEnterBackground() {
        lifeCycleHandler.appDidEnterBackground()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            lifeCycleHandler.handle(task)
        }
    }
}
