//
//  Color+Tint.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

extension Color {
    static let appTint = Self.appBlue

    static let appBlue = AppColor.appBlue.color
    static let appCyan = AppColor.appCyan.color
    static let appGreen = AppColor.appGreen.color
    static let appOrange = AppColor.appOrange.color
    static let appPurple = AppColor.appPurple.color
    static let appRed = AppColor.appRed.color
}

struct AppColor: Hashable {
    let name: String
    let color: Color

    static let appBlue = AppColor(name: "appBlue", color: Color("appBlue"))
    static let appCyan = AppColor(name: "appCyan", color: Color("appCyan"))
    static let appGreen = AppColor(name: "appGreen", color: Color("appGreen"))
    static let appOrange = AppColor(name: "appOrange", color: Color("appOrange"))
    static let appPurple = AppColor(name: "appPurple", color: Color("appPurple"))
    static let appRed = AppColor(name: "appRed", color: Color("appRed"))

    static let all: [AppColor] = [appBlue, appCyan, appGreen, appOrange, appPurple, appRed]
}
