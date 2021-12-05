//
//  UpdateHandler.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 02.09.20.
//

import WatchKit
import UserNotifications
import HealthKit
import CoreInsights

class LifeCycleHandler: NSObject {
    private let dataProvider: DataProvider
    private let healthStore = HKHealthStore()

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func applicationDidFinishLaunching() {
        CoreInsights.logs.track("App launched", level: .info, tags: ["APP"])
        dataProvider.healthData.updateBulk(completion: { })
    }

    func appWillEnterForeground() {
        CoreInsights.logs.track("App Foreground", level: .info, tags: ["APP"])
        dataProvider.healthData.updateBulk(completion: { })
        registerHealthKitUpdates()
    }

    func appDidEnterBackground() {
        CoreInsights.logs.track("App Background", level: .info, tags: ["APP"])
        scheduleNextUpdate(completion: { _ in })
    }

    func registerHealthKitUpdates() {
        if #available(watchOSApplicationExtension 8.0, *) {
            let allTypes = Set([HKObjectType.workoutType()])
            healthStore.requestAuthorization(
                toShare: allTypes,
                read: nil,
                completion: { [weak self] authSuccess, _ in
                    guard authSuccess else {
                        CoreInsights.logs.track("No HK Access", level: .warning, tags: ["APP", "DATA"])
                        return
                    }

                    self?.healthStore.enableBackgroundDelivery(for: .workoutType(), frequency: .immediate, withCompletion: { updateSuccess, _ in
                        CoreInsights.logs.track("HK Background \(updateSuccess)", level: .info, tags: ["APP", "DATA"])
                    })

                    let query = HKObserverQuery(sampleType: .workoutType(), predicate: nil, updateHandler: { [weak self] _, completionHandler, error in
                        guard error != nil else {
                            CoreInsights.logs.track("HK Query Error", level: .error, tags: ["BG"])
                            return
                        }
                        CoreInsights.logs.track("Update Trigger: HK", level: .info, tags: ["BG"])
                        self?.performBackgroundTasks(completion: {
                            completionHandler()
                        })
                    })
                    self?.healthStore.execute(query)
            })
        }
    }

    func handle(_ task: WKRefreshBackgroundTask) {
        switch task {
        case let backgroundTask as WKApplicationRefreshBackgroundTask:
            CoreInsights.logs.track("Update Trigger: Schedule", level: .info, tags: ["BG"])
            performBackgroundTasks(completion: {
                backgroundTask.setTaskCompletedWithSnapshot(false)
            })
        default:
            task.setTaskCompletedWithSnapshot(true)
        }
    }
}

private extension LifeCycleHandler {
    func scheduleNextUpdate(completion: @escaping ((Bool) -> Void)) {
        let minuteGranuity = 2

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

        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: updateDate,
            userInfo: nil,
            scheduledCompletion: { error in
                completion(error == nil)
        })
    }

    func performBackgroundTasks(completion: (() -> Void)) {
        CoreInsights.logs.track("BG Update Start", level: .debug, tags: ["BG", "DATA"])

        let operation1 = BlockOperation { [weak self] in
            let sema = DispatchSemaphore(value: 0)
            self?.scheduleNextUpdate(completion: { _ in
                CoreInsights.logs.track("BG Update Scheduled", level: .debug, tags: ["BG", "DATA"])
                sema.signal()
            })
            sema.wait()
        }
        let operation2 = BlockOperation { [weak self] in
            let hour = Calendar.current.component(.hour, from: Date())
            if hour == 0 {
                let sema = DispatchSemaphore(value: 0)
                self?.dataProvider.healthData.updateBulk(completion: {
                    CoreInsights.logs.track("BG Update 1/1", level: .debug, tags: ["BG", "DATA"])
                    sema.signal()
                })
                sema.wait()
            } else {
                let sema0 = DispatchSemaphore(value: 0)
                let sema1 = DispatchSemaphore(value: 0)
                self?.dataProvider.healthData.updateHour(hour: hour - 1, completion: {
                    CoreInsights.logs.track("BG Update 1/2", level: .debug, tags: ["BG", "DATA"])
                    sema0.signal()
                })
                self?.dataProvider.healthData.updateHour(hour: hour, completion: {
                    CoreInsights.logs.track("BG Update 2/2", level: .debug, tags: ["BG", "DATA"])
                    sema1.signal()
                })
                sema0.wait()
                sema1.wait()
            }
        }

        let loadingQueue = OperationQueue()
        loadingQueue.addOperation(operation1)
        loadingQueue.addOperation(operation2)
        loadingQueue.waitUntilAllOperationsAreFinished()

        CoreInsights.logs.track("BG Update Done", level: .debug, tags: ["BG", "DATA"])

        completion()
    }
}

extension LifeCycleHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}
