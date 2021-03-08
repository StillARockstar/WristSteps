//
//  InfoView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import SwiftUI

struct AboutAppView: View {
    @EnvironmentObject var provider: AboutAppViewProvider

    var body: some View {
        VStack(alignment: .leading) {
            Text("About WristSteps".uppercased())
                .font(.headline)
                .foregroundColor(.appTint)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding([.top, .bottom], 4)

            Text("App Version")
            Text(provider.versionNumber)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 4)

            Text("Copyright")
            Text(provider.copyrightText)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
            .environmentObject(AboutAppViewProvider(dataProvider: SimulatorDataProvider()))
    }
}
