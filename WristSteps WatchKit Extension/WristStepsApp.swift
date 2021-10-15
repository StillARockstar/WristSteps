//
//  WristStepsApp.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import ClockKit
import SwiftUI
import Combine
import UserNotifications

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

        WKNotificationScene(
            controller: StepCountDebugNotificationController.self,
            category: StepCountDebugNotificationController.category
        )
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
        let dataProvider = AppDataProvider()
        #endif
        self.dataProvider = dataProvider
        setupLogging(dataProvider: dataProvider)
        setupNotifications(dataProvider: dataProvider)

        self.dataProvider.healthData.registerHealthKitUpdates()

        XLog("Root URL: \(DataStore.rootDirectory?.absoluteString ?? "")")

        self.iapManager = IAPManager()
        self.iapManager.generateProducts(with: ProductIds.allCases.map({ $0.rawValue }))

        self.lifeCycleHandler = LifeCycleHandler(dataProvider: self.dataProvider)

        self.stepCountPublisher = dataProvider.healthData.stepCountPublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                XLog("New step count: \(newValue)")
                UNUserNotificationCenter.current().addStepCountDebugNotification(newValue: newValue, date: Date())
            }
        self.stepGoalPublisher = dataProvider.userData.stepGoalPublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                XLog("New step goal: \(newValue)")
            }
        self.colorNamePublisher = dataProvider.userData.colorNamePublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
                Color.update(appTint: AppColor.color(forName: newValue).color)
                XLog("New color name: \(newValue)")
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
