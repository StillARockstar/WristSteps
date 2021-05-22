//
//  UpdateHandler.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 02.09.20.
//

import WatchKit

class LifeCycleHandler {
    private let dataProvider: DataProvider

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func appWillEnterForeground() {
        dataProvider.healthData.updateBulk(completion: { })
    }

    func appDidEnterBackground() {
        scheduleNextUpdate(completion: { _ in })
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
            let hour = Calendar.current.component(.hour, from: Date())
            self?.dataProvider.healthData.updateHour(hour: hour, completion: {
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
