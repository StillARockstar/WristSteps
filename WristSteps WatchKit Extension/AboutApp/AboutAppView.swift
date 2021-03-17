//
//  InfoView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.12.20.
//

import SwiftUI

struct AboutAppView: View {
    let provider: AboutAppViewProvider

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HeadingText("About WristSteps")
                .padding(.bottom, 12)

            BodyText("App Version")
            Body1Text(provider.versionNumber)
                .padding(.bottom, 6)

            BodyText("Copyright")
            Body1Text(provider.copyrightText)

            Spacer()
        }
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView(provider: AboutAppViewProvider())
    }
}
