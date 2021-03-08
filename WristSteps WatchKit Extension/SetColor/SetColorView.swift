//
//  SetColorView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import SwiftUI

struct SetColorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var provider: SetColorViewProvider

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
            Text("App Color".uppercased())
                .foregroundColor(.appTint)
            Text("App & Watchface color")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
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
                    .padding()
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

                    Text(item.displayName)
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
                    .foregroundColor(.appTint)
                Text(provider.premiumColorsInfo?.productDescription ?? "")
                    .multilineTextAlignment(.center)
                Text("for \(provider.premiumColorsInfo?.productPrice ?? "")" )
                    .foregroundColor(.appTint)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                Text("One time purchase")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding([.top, .bottom], 5)
            .frame(maxWidth: .infinity)
        })
    }

    private var premiumRestoreView: some View {
        Button(
            "Restore Purchase",
            action: {
                provider.restorePremiumColors()
            }
        )
    }
}

struct SetColorView_Previews: PreviewProvider {
    static var previews: some View {
        SetColorView()
            .environmentObject(
                SetColorViewProvider(
                    dataProvider: SimulatorDataProvider(),
                    iapManager: IAPManager()
                )
            )
    }
}
