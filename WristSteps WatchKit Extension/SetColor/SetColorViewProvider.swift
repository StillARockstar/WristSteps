//
//  SetColorViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.09.20.
//

import Foundation

class SetColorViewProvider: ObservableObject {
    let selectedColorName = "appBlue"
    let availableColors: [AppColor] = AppColor.all

    init() {
        
    }

    func commitColorUpdate(newValue: AppColor) {
        print("new color = \(newValue.name)")
    }
}
