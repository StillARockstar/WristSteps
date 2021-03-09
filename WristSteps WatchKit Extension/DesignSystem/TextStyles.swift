//
//  TextStyles.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 09.03.21.
//

import SwiftUI

struct HeadingText: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.appTint)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
