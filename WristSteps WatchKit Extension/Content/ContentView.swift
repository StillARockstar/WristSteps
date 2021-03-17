//
//  ContentView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 17.03.21.
//

import SwiftUI

struct ContentView: View {
    let provider: ContentViewProvider

    var body: some View {
        HomeView(provider: provider.homeViewProvider)
            .embedInNavigation()
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
