//
//  DateFormatting.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 26.05.21.
//

import Foundation

extension Date {
    var yyyymmddhhmmString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
}
