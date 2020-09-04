//
//  SetColorViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.09.20.
//

import Foundation

class SetColorViewProvider: ObservableObject {
    let availableColors: [AppColor] = AppColor.all

    init() {
        
    }
}
