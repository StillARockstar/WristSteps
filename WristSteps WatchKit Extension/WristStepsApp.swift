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
                ComplicationPayload.shared.set(.stepCount, newValue: newValue)
                CLKComplicationServer.sharedInstance().activeComplications?.forEach {
                    CLKComplicationServer.sharedInstance().reloadTimeline(for: $0)
                }
                NSLog("New step count: \(newValue)")
            }

        super.init()
    }

    func applicationWillEnterForeground() {
        dataProvider.healthData.update(completion: { _ in })
    }

    func applicationDidEnterBackground() {
        scheduleNextUpdate(completion: { _ in })
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                performBackgroundTasks(completion: {
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                })
            default:
                task.setTaskCompletedWithSnapshot(true)
            }
        }
    }
}

private extension ExtensionDelegate {
    func scheduleNextUpdate(completion: @escaping ((Bool) -> Void)) {
        let minuteGranuity = 15

        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        let floorMinute = minute - (minute % minuteGranuity)
        guard let floorDate = calendar.date(bySettingHour: hour, minute: floorMinute, second: 0, of: now),
              let updateDate = calendar.date(byAdding: .minute, value: minuteGranuity, to: floorDate)
        else {
            completion(false)
            return
        }

        WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: updateDate, userInfo: nil, scheduledCompletion: { error in
            completion(error == nil)
        })
    }

    func performBackgroundTasks(completion: (() -> Void)) {
        let operation1 = BlockOperation { [weak self] in
            let sema = DispatchSemaphore(value: 0)
            self?.scheduleNextUpdate(completion: { _ in
                sema.signal()
            })
            sema.wait()
        }
        let operation2 = BlockOperation { [weak self] in
            let sema = DispatchSemaphore(value: 0)
            self?.dataProvider.healthData.update(completion: { _ in
                sema.signal()
            })
            sema.wait()
        }

        let loadingQueue = OperationQueue()
        loadingQueue.addOperation(operation1)
        loadingQueue.addOperation(operation2)
        loadingQueue.waitUntilAllOperationsAreFinished()

        completion()
    }
}
