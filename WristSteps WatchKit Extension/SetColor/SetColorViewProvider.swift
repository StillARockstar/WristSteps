//
//  SetColorViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.09.20.
//

import Foundation

class SetColorViewProvider: ObservableObject {
    private let dataProvider: DataProvider

    let selectedColorName: String
    let availableColors: [AppColor] = AppColor.all

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.selectedColorName = dataProvider.userData.colorName
    }

    func commitColorUpdate(newValue: AppColor) {
        dataProvider.userData.update(colorName: newValue.name)
    }
}
