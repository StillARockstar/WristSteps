//
//  NotificationController.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 10.10.21.
//

import Foundation
import SwiftUI
import UserNotifications

extension UNUserNotificationCenter {
    func addStepCountDebugNotification(newValue: Int, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "New Step Count"
        content.categoryIdentifier = StepCountDebugNotificationController.category
        content.userInfo = ["newValue": newValue, "dateAndTime": date.yyyymmddhhmmString]
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

class StepCountDebugNotificationController: WKUserNotificationHostingController<StepCountDebugNotificationView> {
    static let category = "wriststeps.debug.step_count"
    static let newValueKey: String = "newValue"
    static let dateAndTimeKey: String = "dateAndTime"
    private var newValue: Int = 0
    private var dateAndTime: String = ""

    override func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let newValue = userInfo["newValue"] as? Int else { return }
        guard let dateAndTime = userInfo["dateAndTime"] as? String else { return }
        self.newValue = newValue
        self.dateAndTime = dateAndTime
    }

    override var body: StepCountDebugNotificationView {
        StepCountDebugNotificationView(newValue: newValue, dateAndTime: dateAndTime)
    }
}

struct StepCountDebugNotificationView: View {
    let newValue: Int
    let dateAndTime: String

    var body: some View {
        VStack(spacing: 8){
            VStack {
                HeadingText("Debug Notification")
                BodyText("New Step Count")
            }
            .padding(.bottom, 8)
            VStack {
                BodyText("Step Count", alignment: .leading)
                Body1Text("\(newValue)", alignment: .leading)
            }
            VStack {
                BodyText("Date and Time", alignment: .leading)
                Body1Text(dateAndTime, alignment: .leading)
            }
        }
    }
}

struct StepCountDebugNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        StepCountDebugNotificationView(newValue: 10000, dateAndTime: "2020-10-10 16:45")
    }
}
