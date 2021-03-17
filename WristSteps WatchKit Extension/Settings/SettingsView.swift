//
//  SettingsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import SwiftUI

struct SettingsView: View {
    let provider: SettingsViewProvider
    @State private var showingSetGoal = false
    @State private var showingSetColor = false

    var body: some View {
        ScrollView {
            SettingsButton(emoji: "🏁", label: "Goal", action: {
                showingSetGoal = true
            })
            .sheet(isPresented: $showingSetGoal) {
                SetGoalView(
                    provider: provider.setGoalViewProvider
                )
            }
            SettingsButton(emoji: "🎨", label: "Color", action: {
                showingSetColor = true
            })
            .sheet(isPresented: $showingSetColor) {
                SetColorView(
                    provider: provider.setColorViewProvider
                )
            }
            SettingsButton(emoji: "👋", label: "Help", action: {

            })
            SettingsButton(emoji: "ℹ️", label: "About App", action: {

            })
        }
    }
}

private struct SettingsButton: View {
    let emoji: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
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
