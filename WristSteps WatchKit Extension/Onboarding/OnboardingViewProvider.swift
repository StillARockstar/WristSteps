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
                title: "Set a goal",
                body: "Tap the 🏁 icon to set your daily stepgoal."
            ),
            InfoViewProvider(
                title: "Set a color",
                body: "Tap the 🎨 icon and pick a color for the app and complication."
            ),
            InfoViewProvider(
                title: "Set the complication",
                body: "Go back to your watch face and long press to edit. From there you can select WristSteps as a complication."
            ),
            InfoViewProvider(
                title: "Happy walking!",
                body: "And that is all you to know!",
                action: InfoViewAction(label: "Done", actionBlock: { self.doneAction?() })
            )
        ]

        if showIntroPage {
            pages.insert(
                InfoViewProvider(
                    emoji: "👋",
                    title: "Welcome to Wriststeps",
                    body: "Wriststeps is the app to show steps in your prefered style."
                ),
                at: 0
            )
        }
    }
}
