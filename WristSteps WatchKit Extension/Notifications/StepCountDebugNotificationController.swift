//
//  NotificationController.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 10.10.21.
//

import Foundation
import SwiftUI
import UserNotifications

class StepCountDebugNotificationController: WKUserNotificationHostingController<StepCountDebugNotificationView> {
    static let category = "wriststeps.debug.step_count"
    private var newValue: Int = 0
    private var time: String = ""

    override func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let newValue = userInfo["newValue"] as? Int else { return }
        guard let time = userInfo["dateAndTime"] as? String else { return }
        self.newValue = newValue
        self.time = time
    }

    override var body: StepCountDebugNotificationView {
        StepCountDebugNotificationView(newValue: newValue, time: time)
    }
}

struct StepCountDebugNotificationView: View {
    let newValue: Int
    let time: String

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
                BodyText("Time", alignment: .leading)
                Body1Text(time, alignment: .leading)
            }
        }
    }
}

struct StepCountDebugNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        StepCountDebugNotificationView(newValue: 10000, time: "2020-")
    }
}
