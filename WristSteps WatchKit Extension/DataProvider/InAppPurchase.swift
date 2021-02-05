//
//  InAppPurchase.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.02.21.
//

import Foundation
import StoreKit

enum ProductIds: String, CaseIterable {
    case premiumColors = "at.Schoder.WristSteps.iap.PremiumColors"
}

// MARK: - IAPManager

class IAPManager: NSObject {
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }

    private var productRequest: SKProductsRequest?
    private var products: [String: IAPProduct] = [:]

    func generateProducts(with idenfifiers: [String]) {
        for identifier in idenfifiers {
            self.products[identifier] = IAPProduct(manager: self, identifier: identifier)
        }

        self.fetchProductInformations(with: idenfifiers)
        self.fetchPurchased(with: idenfifiers)
    }

    func getProduct(for identifier: String) -> IAPProduct? {
        self.products[identifier]
    }
}

extension IAPManager {
    private func fetchPurchased(with idenfifiers: [String]) {
        for idenfifier in idenfifiers {
            let isProductPurchsed = self.isProductPurchsed(identifier: idenfifier)
            self.products[idenfifier]?.setPurchased(isProductPurchsed)
        }
    }

    private func isProductPurchsed(identifier: String) -> Bool {
        DataStore.namespace(DataStoreConstants.namespace).get(key: DataStoreConstants.premiumColorsKey) as? Bool ?? false
    }

    private func setProductPurchased(identifier: String, _ value: Bool) {
        DataStore.namespace(DataStoreConstants.namespace).set(value: value, for: DataStoreConstants.premiumColorsKey)
    }

    private struct DataStoreConstants {
        static let namespace = "purchase_data"
        static let premiumColorsKey = "premium_colors"
    }
}

extension IAPManager: SKProductsRequestDelegate {
    private func fetchProductInformations(with idenfifiers: [String]) {
        self.productRequest = SKProductsRequest(productIdentifiers: Set(idenfifiers))
        self.productRequest?.delegate = self
        self.productRequest?.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            let identifier = product.productIdentifier
            self.getProduct(for: identifier)?.setProduct(product)
        }
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func purchaseProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let productIdentifier = transaction.payment.productIdentifier

            switch transaction.transactionState {
            case .purchased, .restored:
                self.setProductPurchased(
                    identifier: productIdentifier,
                    true
                )
                self.getProduct(for: productIdentifier)?.setPurchased(true)
            case .failed:
                self.setProductPurchased(
                    identifier: productIdentifier,
                    false
                )
                self.getProduct(for: productIdentifier)?.setPurchased(false)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}

// MARK: - IAPProduct

struct ProductInformation {
    var productTitle: String
    var productDescription: String
    var productPrice: String
}

class IAPProduct: NSObject, ObservableObject {
    private let manager: IAPManager
    private let identifier: String
    private var product: SKProduct? {
        didSet {
            guard let product = self.product else { return }
            self.information = ProductInformation(
                productTitle: product.localizedTitle,
                productDescription: product.localizedDescription,
                productPrice: product.localizedPrice
            )
        }
    }

    @Published private(set) var information: ProductInformation?
    @Published private(set) var purchased: Bool = false

    init(manager: IAPManager, identifier: String) {
        self.manager = manager
        self.identifier = identifier
        super.init()
    }

    func setProduct(_ product: SKProduct) {
        self.product = product
    }

    func setPurchased(_ purchased: Bool) {
        self.purchased = purchased
    }
}

extension IAPProduct {
    func buy() {
        guard let product = self.product else { return }
        self.manager.purchaseProduct(product)
    }

    func restore() {
        self.manager.restore()
    }
}

private extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
