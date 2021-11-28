//
//  UpdateHandler.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 02.09.20.
//

import WatchKit
import UserNotifications
import HealthKit

class LifeCycleHandler: NSObject {
    private let dataProvider: DataProvider
    private let healthStore = HKHealthStore()

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func applicationDidFinishLaunching() {
        dataProvider.healthData.updateBulk(completion: { })
    }

    func appWillEnterForeground() {
        dataProvider.healthData.updateBulk(completion: { })
        registerHealthKitUpdates()
    }

    func appDidEnterBackground() {
        scheduleNextUpdate(completion: { _ in })
    }

    func registerHealthKitUpdates() {
        if #available(watchOSApplicationExtension 8.0, *) {
            let allTypes = Set([HKObjectType.workoutType()])
            healthStore.requestAuthorization(toShare: allTypes, read: nil, completion: { [weak self] authSuccess, _ in
                XLog("HealthKit Authorization successful: \(authSuccess)")
                guard authSuccess else {
                    return
                }

                self?.healthStore.enableBackgroundDelivery(for: .workoutType(), frequency: .immediate, withCompletion: { updateSuccess, _ in
                    XLog("Workout Background delivery setup successful: \(updateSuccess)")
                })

                let query = HKObserverQuery(sampleType: .workoutType(), predicate: nil, updateHandler: { [weak self] _, completionHandler, error in
                    guard error != nil else {
                        return
                    }
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
        let operation1 = BlockOperation { [weak self] in
            let sema = DispatchSemaphore(value: 0)
            self?.scheduleNextUpdate(completion: { _ in
                sema.signal()
            })
            sema.wait()
        }
        let operation2 = BlockOperation { [weak self] in
            let hour = Calendar.current.component(.hour, from: Date())
            if hour == 0 {
                let sema = DispatchSemaphore(value: 0)
                self?.dataProvider.healthData.updateBulk(completion: {
                    sema.signal()
                })
                sema.wait()
            } else {
                let sema0 = DispatchSemaphore(value: 0)
                let sema1 = DispatchSemaphore(value: 0)
                self?.dataProvider.healthData.updateHour(hour: hour - 1, completion: {
                    sema0.signal()
                })
                self?.dataProvider.healthData.updateHour(hour: hour, completion: {
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

        self.dataProvider.appData.setLastBackgroundUpdate(Date().yyyymmddhhmmString)

        completion()
    }
}

extension LifeCycleHandler: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
}
