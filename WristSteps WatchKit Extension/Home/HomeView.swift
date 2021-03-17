//
//  HomeView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var provider: HomeViewProvider

    var body: some View {
        VStack {
            Spacer()
            DetailView(
                stepCount: provider.stepCount,
                stepGoal: provider.stepGoal
            )
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            provider: HomeViewProvider(
                dataProvider: SimulatorDataProvider(),
                iapManager: IAPManager()
            )
        )
    }
}
