//
//  SetColorView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import SwiftUI

struct SetColorView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var provider: SetColorViewProvider

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        List {
            VStack {
                headerView
                standardGridView
            }
            .listRowBackground(Color.clear)

            if provider.hasPremiumColorsUnlocked {
                premiumListView
            }
            if !provider.hasPremiumColorsUnlocked && provider.canPurchasePremiumColors {
                premiumPurchaseView
                premiumRestoreView
            }
        }
        .sheet(
            item: $provider.restorePurchaseResult,
            content: { provider in
                InfoView(provider: provider)
            })
    }

    private var headerView: some View {
        VStack {
            Text("setColor.title")
                .font(.headline)
                .foregroundColor(.appTint)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("setColor.text")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var standardGridView: some View {
        LazyVGrid(columns: columns, spacing: 0){
            ForEach(provider.availableStandardColors, id: \.self) { item in
                Button(
                    action: {
                        provider.commitColorUpdate(newValue: item)
                        presentationMode.wrappedValue.dismiss()
                    },
                    label: {
                        Image(systemName:
                            item.name == provider.selectedColorName ? "checkmark.circle.fill" : "circle.fill"
                        )
                    }
                )
                    .padding(4)
                    .font(.title)
                    .foregroundColor(item.color)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .listRowBackground(Color.clear)
    }

    private var premiumListView: some View {
        ForEach(provider.availablePremiumColors, id: \.name, content: { item in
            Button(action: {
                provider.commitColorUpdate(newValue: item)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName:
                        item.name == provider.selectedColorName ? "checkmark.circle.fill" : "circle.fill"
                    )
                    .foregroundColor(item.color)
                    .font(Font.system(size: 25))

                    Text(LocalizedStringKey(item.localizationKey))
                }
            })
        })
    }

    private var premiumPurchaseView: some View {
        Button(action: {
            provider.purchasePremiumColors()
        }, label: {
            VStack(spacing: 5) {
                Text(provider.premiumColorsInfo?.productTitle ?? "")
                    .font(.headline)
                    .foregroundColor(.appTint)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(provider.premiumColorsInfo?.productDescription ?? "")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("setColor.iap.price \(provider.premiumColorsInfo?.productPrice ?? "")" )
                    .font(.headline)
                    .foregroundColor(.appTint)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("setColor.iap.info")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding([.top, .bottom], 5)
            .frame(maxWidth: .infinity)
        })
    }

    private var premiumRestoreView: some View {
        Button(
            "setColor.iap.restore",
            action: {
                provider.restorePremiumColors()
            }
        )
    }
}

struct SetColorView_Previews: PreviewProvider {
    static var previews: some View {
        SetColorView(
            provider: SetColorViewProvider(
                dataProvider: SimulatorDataProvider(),
                iapManager: IAPManager()
            )
        )
    }
}
