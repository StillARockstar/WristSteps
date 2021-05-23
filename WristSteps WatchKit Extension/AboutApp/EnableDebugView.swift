//
//  EnableDebugView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import SwiftUI

struct EnableDebugView: View {
    @ObservedObject var provider: AboutAppViewProvider

    var body: some View {
        VStack {
            HeadingText("Enable Debugging")
            BodyText("For Developer only!")
            Toggle("Enabled", isOn: $provider.debuggingEnabled)
                .padding(.all, 10)
                .disabled(provider.debugConfiguration)
            if provider.debugConfiguration {
                Body1Text("Debugging in DEBUG configuration always enabled")
            }
            Spacer()
        }
    }
}

struct EnableDebugView_Previews: PreviewProvider {
    static var previews: some View {
        EnableDebugView(
            provider: AboutAppViewProvider(
                dataProvider: SimulatorDataProvider()
            )
        )
    }
}
