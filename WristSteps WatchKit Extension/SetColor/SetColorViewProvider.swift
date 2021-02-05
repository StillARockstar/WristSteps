//
//  SetColorViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.09.20.
//

import Foundation
import Combine

class SetColorViewProvider: ObservableObject {
    private let dataProvider: DataProvider
    private let iapProduct: IAPProduct?
    private let iapManager: IAPManager
    private var iapPurchasedPublisher: AnyCancellable?
    private var iapInfoPublisher: AnyCancellable?

    let selectedColorName: String
    let availableStandardColors: [AppColor] = AppColor.standard
    let availablePremiumColors: [AppColor] = AppColor.premium

    @Published var hasPremiumColorsUnlocked: Bool = false
    @Published var canPurchasePremiumColors: Bool = false
    @Published var premiumColorsInfo: ProductInformation?

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
        self.selectedColorName = dataProvider.userData.colorName

        self.iapProduct = self.iapManager.getProduct(for: ProductIds.premiumColors.rawValue)
        self.iapPurchasedPublisher = self.iapProduct?.$purchased
            .sink(receiveValue: { [weak self] value in
                DispatchQueue.main.async {
                    self?.hasPremiumColorsUnlocked = value
                }
            })
        self.iapInfoPublisher = self.iapProduct?.$information
            .sink(receiveValue: { [weak self] information in
                DispatchQueue.main.async {
                    self?.premiumColorsInfo = information
                    self?.canPurchasePremiumColors = information != nil
                }
            })
    }

    func commitColorUpdate(newValue: AppColor) {
        dataProvider.userData.update(colorName: newValue.name)
    }

    func purchasePremiumColors() {
        iapProduct?.buy()
    }

    func restorePremiumColors() {
        iapProduct?.restore()
    }
}
