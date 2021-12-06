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
            Text("Enable Debugging")
                .font(.headline)
                .foregroundColor(.appTint)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text("For Developer only!")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Toggle("Enabled", isOn: $provider.debuggingEnabled)
                .padding(.all, 10)
                .disabled(provider.debugConfiguration)
            if provider.debugConfiguration {
                Text("Debugging in DEBUG configuration always enabled")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
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
