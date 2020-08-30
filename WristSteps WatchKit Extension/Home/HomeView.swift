//
//  HomeView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            DetailView(currentStepCount: 5000, currentStepGoal: 10000)
            Spacer()
            HStack {
                Button("🏁", action: { })
                Button("🎨", action: { })
            }
        }
        .navigationBarTitle("WristSteps")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
