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

            premiumListView
        }
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
