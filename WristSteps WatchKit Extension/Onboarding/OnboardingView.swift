//
//  OnboardingView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.01.21.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.presentationMode) var presentationMode
    let provider: OnboardingViewProvider

    var body: some View {
        registerDoneAction()
        return TabView {
            ForEach(provider.pages, content: { infoViewProvider in
                InfoView(provider: infoViewProvider)
            })
        }
        .tabViewStyle(PageTabViewStyle())
    }

    func registerDoneAction() {
        provider.doneAction = {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(provider: OnboardingViewProvider())
    }
}
