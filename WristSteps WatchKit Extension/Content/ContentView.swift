//
//  ContentView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import SwiftUI

struct ContentView: View {
    let provider: ContentViewProvider
    @State private var tabSelection: Int = 1
    @State private var showingOnboarding = false

    var body: some View {
        TabView(
            selection: $tabSelection,
            content:  {
                if #available(watchOSApplicationExtension 8.0, *) {
                    SettingsView(provider: provider.settingsViewProvider)
                        .navigationBarTitle("Settings")
                        .navigationBarTitleDisplayMode(.inline)
                        .embedInNavigation()
                        .tag(0)
                    HomeView(provider: provider.homeViewProvider)
                        .navigationBarTitle("WristSteps")
                        .navigationBarTitleDisplayMode(.inline)
                        .embedInNavigation()
                        .tag(1)
                } else {
                    SettingsView(provider: provider.settingsViewProvider)
                        .navigationBarTitle("Settings")
                        .embedInNavigation()
                        .tag(0)
                    HomeView(provider: provider.homeViewProvider)
                        .navigationBarTitle("WristSteps")
                        .embedInNavigation()
                        .tag(1)
                }
            }
        )
        .sheet(isPresented: $showingOnboarding) {
            OnboardingView(
                provider: provider.onboardingProvider
            )
        }
        .onAppear(perform: {
            showingOnboarding = provider.shouldShowOnboardingAndSetFlag()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            provider: ContentViewProvider(
                dataProvider: SimulatorDataProvider(),
                iapManager: IAPManager()
            )
        )
    }
}
