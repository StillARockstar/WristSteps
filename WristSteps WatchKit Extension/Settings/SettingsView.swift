//
//  SettingsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import SwiftUI

struct SettingsView: View {
    let provider: SettingsViewProvider

    var body: some View {
        ScrollView {
            VStack {
                SettingsButton(emoji: "🏁", label: "Goal")
                SettingsButton(emoji: "🎨", label: "Color")
                SettingsButton(emoji: "👋", label: "Help")
                SettingsButton(emoji: "ℹ️", label: "About App")
            }
        }
    }
}

private struct SettingsButton: View {
    let emoji: String
    let label: String

    var body: some View {
        Button(
            action: {},
            label: {
                HStack(spacing: 10) {
                    Text(emoji)
                    Text(label)
                    Spacer()
                }
                .padding(.leading, 4)
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            provider: SettingsViewProvider(
                dataProvider: SimulatorDataProvider(),
                iapManager: IAPManager()
            )
        )
    }
}
