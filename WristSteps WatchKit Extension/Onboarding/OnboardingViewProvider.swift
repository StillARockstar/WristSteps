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
    let pages: [OnboardingPageProvider]

    init() {
        self.pages = [
            OnboardingPageProvider(
                headline: "Welcome to Wriststeps",
                description: "Wriststeps is the app to show steps in your prefered style."
            ),
            OnboardingPageProvider(
                headline: "Set a goal",
                description: "Press the 🏁 icon to set you stepgoal."
            ),
            OnboardingPageProvider(
                headline: "Set a color",
                description: "Press the 🎨 icon and pick a color for the app and complication."
            ),
            OnboardingPageProvider(
                headline: "Set the complication",
                description: "Go back to your watch face and long press to edit. From there you can select WristSteps."
            )
        ]
    }
}
