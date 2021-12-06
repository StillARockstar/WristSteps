//
//  SettingsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import SwiftUI
import CoreAnalytics

struct SettingsView: View {
    let provider: SettingsViewProvider
    @State private var showingSetGoal = false
    @State private var showingSetColor = false
    @State private var showingHelp = false
    @State private var showingAboutApp = false
    @State private var showingDebugMenu = false

    var body: some View {
        ScrollView {
            SettingsButton(emoji: "🏁", label: "settings.goal", action: {
                showingSetGoal = true
            })
            .sheet(isPresented: $showingSetGoal) {
                SetGoalView(
                    provider: provider.setGoalViewProvider
                )
            }
            SettingsButton(emoji: "🎨", label: "settings.color", action: {
                showingSetColor = true
            })
            .sheet(isPresented: $showingSetColor) {
                SetColorView(
                    provider: provider.setColorViewProvider
                )
            }
            SettingsButton(emoji: "👋", label: "settings.help", action: {
                showingHelp = true
            })
            .sheet(isPresented: $showingHelp) {
                OnboardingView(
                    provider: provider.onboardingProvider
                )
            }
            SettingsButton(emoji: "ℹ️", label: "settings.aboutApp", action: {
                showingAboutApp = true
            })
            .sheet(isPresented: $showingAboutApp) {
                AboutAppView(
                    provider: provider.aboutAppProvider
                )
            }
            if provider.debugMenuAvailable {
                SettingsButton(emoji: "🐛", label: "settings.debugMenu", action: {
                    showingDebugMenu = true
                })
                .sheet(isPresented: $showingDebugMenu) {
                    DebugMenuView(
                        provider: provider.debugMenuProvider
                    )
                }
            }
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
                    Text(LocalizedStringKey(label))
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
