//
//  SetColorViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.09.20.
//

import Foundation

class SetColorViewProvider: ObservableObject {
    private let dataProvider: DataProvider
    private let iapManager: IAPManager

    let selectedColorName: String
    let availableColors: [AppColor] = AppColor.all

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
        self.selectedColorName = dataProvider.userData.colorName
    }

    func commitColorUpdate(newValue: AppColor) {
        dataProvider.userData.update(colorName: newValue.name)
    }
}
