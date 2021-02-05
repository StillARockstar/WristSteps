//
//  Color+Tint.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

extension Color {
    static private(set) var appTint = AppColor.appBlue.color

    static func update(appTint: Color) {
        Self.appTint = appTint
    }
}

struct AppColor: Hashable {
    let name: String
    let displayName: String
    let color: Color    

    static func color(forName name: String) -> AppColor {
        return all.first(where: { $0.name == name }) ?? .appBlue
    }

    init(name: String, displayName: String, color: Color) {
        self.name = name
        self.displayName = displayName
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
