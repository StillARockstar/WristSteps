//
//  DetailView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

struct DetailView: View {
    let tintColor: Color
    let stepCount: Int
    let stepGoal: Int

    private var stepPercent: Double {
        (Double(stepCount) / Double(stepGoal)) * 100
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today")
                    .foregroundColor(.gray)
                Text("\(stepPercent, specifier: "%.0f")%")
                    .foregroundColor(tintColor)
                    .fontWeight(.semibold)
            }
            HStack(alignment: .bottom) {
                Text("\(stepCount)")
                    .foregroundColor(tintColor)
                    .font(.title)
                Text("steps")
                    .fontWeight(.medium)
                    .padding(.bottom, 5)
            }
            HStack {
                Text("Goal")
                    .foregroundColor(.gray)
                Text("\(stepGoal) steps")
                    .fontWeight(.medium)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(
            tintColor: AppColor.appBlue.color,
            stepCount: 5000,
            stepGoal: 10000
        )
    }
}
