//
//  NotificationController.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 10.10.21.
//

import Foundation
import SwiftUI
import UserNotifications

struct DebugNotificationKeyValue: Hashable, Codable {
    let key: String
    let value: String
}

extension UNUserNotificationCenter {
    func addDebugNotification(title: String, keyValues: [DebugNotificationKeyValue]) {
        guard debugNotificationsEnabled else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.categoryIdentifier = DebugNotificationController.category
        guard let keyValuesData = try? JSONEncoder().encode(keyValues) else { return }
        content.userInfo = ["title": title, "keyValues": keyValuesData]
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

class DebugNotificationController: WKUserNotificationHostingController<DebugNotificationView> {
    static let category = "wriststeps.debug_notification"
    private var title: String = ""
    private var keyValues: [DebugNotificationKeyValue] = []

    override func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let title = userInfo["title"] as? String else { return }
        guard let keyValuesData = userInfo["keyValues"] as? Data else { return }
        guard let keyValues = try? JSONDecoder().decode([DebugNotificationKeyValue].self, from: keyValuesData) else { return }
        self.title = title
        self.keyValues = keyValues
    }

    override var body: DebugNotificationView {
        DebugNotificationView(title: title, keyValues: keyValues)
    }
}

struct DebugNotificationView: View {
    let title: String
    let keyValues: [DebugNotificationKeyValue]

    var body: some View {
        VStack(spacing: 8){
            VStack {
                HeadingText("Debug Notification")
                BodyText(title)
            }
            .padding(.bottom, 8)
            ForEach(keyValues, id: \.self, content: { entry in
                VStack {
                    BodyText(entry.key, alignment: .leading)
                    Body1Text(entry.value, alignment: .leading)
                }
            })
        }
    }
}

struct DebugNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        DebugNotificationView(
            title: "New Step Count",
            keyValues: [
                DebugNotificationKeyValue(key: "Step Count", value: "10000"),
                DebugNotificationKeyValue(key: "Date and Time", value: "2021-10-15 20:25")
            ]
        )
    }
}
