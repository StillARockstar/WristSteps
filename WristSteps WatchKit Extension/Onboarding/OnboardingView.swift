//
//  OnboardingView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.01.21.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var provider: OnboardingViewProvider
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        TabView {
            ForEach(provider.pages, content: { infoViewProvider in
                InfoView(provider: infoViewProvider)
            })
        }
        .tabViewStyle(PageTabViewStyle())
        .onAppear(perform: {
            provider.doneAction = {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingViewProvider())
    }
}
