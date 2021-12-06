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
import CoreAnalytics
import CoreTracking

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

        if dataProvider.appData.debuggingEnabled && dataProvider.appData.isPhysicalWatch {
            CoreTracking.configureInsights([.logFiles])
        } else if dataProvider.appData.debuggingEnabled && !dataProvider.appData.isPhysicalWatch {
            CoreTracking.configureInsights([.logFiles, .console])
            print("Root URL: \(DataStore.rootDirectory?.absoluteString ?? "")")
        } else {
            CoreTracking.configureInsights([])
        }
        CoreAnalytics.configureInsights()

        self.iapManager = IAPManager()
        self.iapManager.generateProducts(with: ProductIds.allCases.map({ $0.rawValue }))

        self.lifeCycleHandler = LifeCycleHandler(dataProvider: self.dataProvider)

        self.stepCountPublisher = dataProvider.healthData.stepCountPublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                CoreTracking.logs.track("New Steps \(newValue)", level: .info, tags: ["DATA"])
            }
        self.stepGoalPublisher = dataProvider.userData.stepGoalPublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                CoreTracking.logs.track("New Goal \(newValue)", level: .info, tags: ["DATA"])
            }
        self.colorNamePublisher = dataProvider.userData.colorNamePublisher
            .removeDuplicates()
            .sink { newValue in
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
                Color.update(appTint: AppColor.color(forName: newValue).color)
                CoreTracking.logs.track("New Color \(newValue)", level: .info, tags: ["DATA"])
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
