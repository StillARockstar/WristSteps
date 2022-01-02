//
//  OnboardingViewProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 04.01.21.
//

import Foundation
import Combine

struct OnboardingPageProvider: Identifiable {
    let id = UUID()
    let headline: String
    let description: String
}

class OnboardingViewProvider: ObservableObject {
    var pages: [InfoViewProvider] = []
    var doneAction: (() -> Void)?

    init(showIntroPage: Bool = true) {
        pages = [
            InfoViewProvider(
                title: "onboarding.setGoal.title",
                body: "onboarding.setGoal.text"
            ),
            InfoViewProvider(
                title: "onboarding.setColor.title",
                body: "onboarding.setColor.text"
            ),
            InfoViewProvider(
                title: "onboarding.complication.title",
                body: "onboarding.complication.text"
            ),
            InfoViewProvider(
                title: "onboarding.done.title",
                body: "onboarding.done.text",
                action: InfoViewAction(label: "onboarding.done.button", actionBlock: { self.doneAction?() })
            )
        ]

        if showIntroPage {
            pages.insert(
                InfoViewProvider(
                    emoji: "👋",
                    title: "onboarding.welcome.title",
                    body: "onboarding.welcome.text"
                ),
                at: 0
            )
        }
    }
}
