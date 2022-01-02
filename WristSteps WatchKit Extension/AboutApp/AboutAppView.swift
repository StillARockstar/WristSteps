//
//  InfoView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import SwiftUI

struct AboutAppView: View {
    let provider: AboutAppViewProvider
    @State private var showingEnableDebugging = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("aboutApp.title")
                .font(.headline)
                .foregroundColor(.appTint)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 12)

            Text("aboutApp.version.title")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(provider.versionNumber)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 6)

            Text("aboutApp.copyright.title")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(provider.copyrightText)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()
        }
        .onTapGesture(count: 3, perform: {
            showingEnableDebugging = true
        })
        .sheet(isPresented: $showingEnableDebugging) {
            EnableDebugView(provider: provider)
        }
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView(
            provider: AboutAppViewProvider(
                dataProvider: SimulatorDataProvider()
            )
        )
    }
}
