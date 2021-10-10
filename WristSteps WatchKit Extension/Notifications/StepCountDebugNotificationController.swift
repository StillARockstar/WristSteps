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

    override func didReceive(_ notification: UNNotification) {
        
    }

    override var body: StepCountDebugNotificationView {
        StepCountDebugNotificationView()
    }
}

struct StepCountDebugNotificationView: View {
    var body: some View {
        Text("My Custom View!!")
    }
}
