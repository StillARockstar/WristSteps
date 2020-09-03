//
//  NumberFormatting.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import Foundation

extension Int {

    var kFormattedString: String {
        if self >= 1000 {
            let value = (Double(self) / Double(1000)).roundToDigits(places: 1)
            let number = NSNumber(value: value)
            let numberString = NumberFormatter.localizedString(from: number, number: .decimal)
            return "\(numberString)k"
        }

        return String(format: "%d", self)
    }
}

extension Double {
    func roundToDigits(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
