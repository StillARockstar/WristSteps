//
//  HomeView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.appTint) var appTintColor: Color
    @ObservedObject var provider: HomeViewProvider

    var body: some View {
        VStack {
            DetailView(
                tintColor: appTintColor,
                stepCount: provider.stepCount,
                stepGoal: provider.stepGoal
            )
            .padding(.bottom, 6)
            BarChartView(
                color: appTintColor,
                data: provider.hourlySteps
            )
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
