//
//  DetailView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct DetailView: View {
    let currentStepCount: Int
    let currentStepGoal: Int

    private var currentStepPercent: Int {
        Int((Double(currentStepCount) / Double(currentStepGoal)) * 100)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TODAY")
                    .foregroundColor(.gray)
                Text("\(currentStepPercent)%")
                    .foregroundColor(.appTint)
                    .fontWeight(.semibold)
            }
            HStack(alignment: .bottom) {
                Text("\(currentStepCount)")
                    .foregroundColor(.appTint)
                    .font(.title)
                Text("steps")
                    .fontWeight(.medium)
                    .padding(.bottom, 5)
            }
            HStack {
                Text("GOAL")
                    .foregroundColor(.gray)
                Text("\(currentStepGoal) steps")
                    .fontWeight(.medium)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(currentStepCount: 5000, currentStepGoal: 10000)
    }
}
