//
//  InfoView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.03.21.
//

import SwiftUI

struct InfoViewProvider: Identifiable {
    let id = UUID()
    let emoji: String?
    let title: String
    let body: String

    init(emoji: String? = nil, title: String, body: String) {
        self.emoji = emoji
        self.title = title
        self.body = body
    }
}

struct InfoView: View {
    let provider: InfoViewProvider

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let emoji = self.provider.emoji {
                    Text(emoji)
                        .font(.largeTitle)
                }
                Text(self.provider.title)
                    .font(.headline)
                    .foregroundColor(.appTint)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text(self.provider.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(
            provider: InfoViewProvider(
                emoji: "👋",
                title: "Info View Title",
                body: "This is the body is of an info view! It is scollable. And it is awesome and my be super long"
            )
        )
        InfoView(
            provider: InfoViewProvider(
                title: "Info View Title",
                body: "This is the body is of an info view! It is scollable. And it is awesome and my be super long"
            )
        )
    }
}
