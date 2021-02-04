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
        VStack {
            Text("App Color".uppercased())
                .foregroundColor(.appTint)
            Text("App & Complication color")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()

            LazyVGrid(columns: columns, spacing: 5){
                ForEach(provider.availableColors, id: \.self) { item in
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
        }
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
