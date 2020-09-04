//
//  HomeView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct HomeView: View {
    @State var showingSetGoal = false
    @State var showingSetColor = false
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
                    .sheet(isPresented: $showingSetGoal, content: {
                        SetGoalView()
                            .environmentObject(provider.setGoalViewProvider)
                    })
                Button("🎨", action: { showingSetColor.toggle() })
                    .sheet(isPresented: $showingSetColor, content: {
                        SetColorView()
                            .environmentObject(provider.setColorViewProvider)
                    })
            }
        }
        .navigationBarTitle("WristSteps")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewProvider(dataProvider: SimulatorDataProvider()))
    }
}
