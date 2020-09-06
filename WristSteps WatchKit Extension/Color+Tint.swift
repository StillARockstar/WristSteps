//
//  Color+Tint.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

extension Color {
    static private(set) var appTint = Color.appBlue

    static let appBlue = AppColor.appBlue.color
    static let appCyan = AppColor.appCyan.color
    static let appGreen = AppColor.appGreen.color
    static let appOrange = AppColor.appOrange.color
    static let appPurple = AppColor.appPurple.color
    static let appRed = AppColor.appRed.color

    static func update(appTint: Color) {
        Self.appTint = appTint
    }
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

    static func color(forName name: String) -> AppColor {
        return all.first(where: { $0.name == name }) ?? .appBlue
    }

    private init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
}

extension EnvironmentValues {
    var appTint: Color {
        get { return Color.appTint }
        set { } 
    }
}

extension UIImage {
    func imageWithColor(newColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        newColor.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
