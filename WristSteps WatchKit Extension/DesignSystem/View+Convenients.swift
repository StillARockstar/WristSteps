//
//  View+Embed.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 02.09.20.
//

import SwiftUI

extension View {

    func embedInNavigation() -> NavigationView<Self> {
        NavigationView {
            self
        }
    }

    func asAnyView() -> AnyView {
        AnyView(self)
    }
}
