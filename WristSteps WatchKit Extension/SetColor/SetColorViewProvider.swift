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
    private var cancellables: [AnyCancellable?] = []

    let selectedColorName: String
    let availableStandardColors: [AppColor] = AppColor.standard
    let availablePremiumColors: [AppColor] = AppColor.premium

    @Published var hasPremiumColorsUnlocked: Bool = false
    @Published var canPurchasePremiumColors: Bool = false
    @Published var premiumColorsInfo: ProductInformation?
    @Published var restorePurchaseResult: InfoViewProvider?

    init(dataProvider: DataProvider, iapManager: IAPManager) {
        self.dataProvider = dataProvider
        self.iapManager = iapManager
        self.selectedColorName = dataProvider.userData.colorName

        self.iapProduct = self.iapManager.getProduct(for: ProductIds.premiumColors.rawValue)
        self.cancellables.append(
            self.iapProduct?.$purchased
                .sink(receiveValue: { [weak self] value in
                    DispatchQueue.main.async {
                        self?.hasPremiumColorsUnlocked = value
                    }
                })
        )
        self.cancellables.append(
            self.iapProduct?.$information
                .sink(receiveValue: { [weak self] information in
                    DispatchQueue.main.async {
                        self?.premiumColorsInfo = information
                        self?.canPurchasePremiumColors = information != nil
                    }
                })
        )
        self.cancellables.append(
            iapManager.restoreEvents.sink(receiveValue: { [weak self] restoredState in
                DispatchQueue.main.async {
                    switch restoredState {
                    case .success:
                        self?.restorePurchaseResult = InfoViewProvider(
                            emoji: "👍",
                            title: "setColor.restore.restoredTitle",
                            body: "setColor.restore.restoredText"
                        )
                    case .noPurchases:
                        self?.restorePurchaseResult = InfoViewProvider(
                            emoji: "🤷‍♂️",
                            title: "setColor.restore.noPurchaseTitle",
                            body: "setColor.restore.noPurchaseText"
                        )
                    case .failed:
                        self?.restorePurchaseResult = InfoViewProvider(
                            emoji: "😬",
                            title: "setColor.restore.errorTitle",
                            body: "setColor.restore.errorText"
                        )
                    }
                }
            })
        )
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
