//
//  HomeView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct HomeView: View {
    @State var showingSetGoal = false
    @EnvironmentObject var provider: HomeViewProvider

    var body: some View {
        VStack {
            Spacer()
            DetailView(
                stepCount: provider.stepCount,
                stepGoal: provider.stepGoal
            )
            Spacer()
            HStack {
                Button("🏁", action: { showingSetGoal.toggle() })
                Button("🎨", action: { })
            }
        }
        .navigationBarTitle("WristSteps")
        .sheet(isPresented: $showingSetGoal, content: {
                SetGoalView()
                    .environmentObject(provider.setGoalViewProvider)
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewProvider(dataProvider: SimulatorDataProvider()))
    }
}
