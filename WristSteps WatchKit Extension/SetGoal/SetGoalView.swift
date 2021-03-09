//
//  SetGoalView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import SwiftUI

struct SetGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var provider: SetGoalViewProvider

    var body: some View {
        VStack {
            HeadingText("Stepgoal")
            Text("The recommended amount of steps is \(provider.recommendedStepGoal) per day")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()

            HStack {
                Button(
                    action: { provider.stepGoal -= provider.incrementSize },
                    label: { Image(systemName: "minus") }
                )
                .buttonStyle(RoundTintedStyle())
                .padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)

                Spacer()
                Text("\(Int(provider.stepGoal).kFormattedString)")
                    .font(.title)
                Spacer()

                Button(
                    action: { provider.stepGoal += provider.incrementSize },
                    label: { Image(systemName: "plus") }
                )
                .buttonStyle(RoundTintedStyle())
                .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            }
            .focusable(true)
            .digitalCrownRotation(
                $provider.stepGoal,
                from: provider.minimumStepGoal,
                through: provider.maximumStepGoal,
                by: provider.incrementSize,
                sensitivity: .high
            )

            Spacer()
            Button("Update Goal", action: {
                provider.commitStepGoalUpdate()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SetGoalView_Previews: PreviewProvider {
    static var previews: some View {
        SetGoalView()
            .environmentObject(SetGoalViewProvider(dataProvider: SimulatorDataProvider()))
    }
}

private struct RoundTintedStyle: ButtonStyle {
    private let size: CGFloat = 15.0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size, alignment: .center)
            .padding()
            .background(Color.appTint)
            .foregroundColor(.black)
            .font(.headline)
            .cornerRadius(size)
    }
}
