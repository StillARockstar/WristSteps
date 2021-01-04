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
            ForEach(provider.pages, content: { pageProvider in
                OnboardingPageView(provider: pageProvider)
            })
            OnboardingDoneView(action: {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

private struct OnboardingPageView: View {
    let provider: OnboardingPageProvider

    var body: some View {
        VStack(spacing: 5) {
            Text(provider.headline)
                .font(.headline)
                .foregroundColor(.appTint)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Text(provider.description)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .padding(.top, 5)
    }
}

private struct OnboardingDoneView: View {
    let action: () -> Void

    var body: some View {
        VStack {
            Text("... and thats it!")
                .font(.headline)
                .foregroundColor(.appTint)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 5)
            Button("Done", action: action)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingViewProvider())
    }
}
