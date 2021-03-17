//
//  ContentView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import SwiftUI

struct ContentView: View {
    let provider: ContentViewProvider
    @State var tabSelection: Int = 1

    var body: some View {
        TabView(
            selection: $tabSelection,
            content:  {
                SettingsView(provider: provider.settingsViewProvider)
                    .navigationBarTitle("Settings")
                    .embedInNavigation()
                    .tag(0)
                HomeView(provider: provider.homeViewProvider)
                    .navigationBarTitle("WristSteps")
                    .embedInNavigation()
                    .tag(1)
            }
        )

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
