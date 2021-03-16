//
//  InfoView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 08.03.21.
//

import SwiftUI

struct InfoViewAction {
    let label: String
    let actionBlock: (() -> Void)
}

struct InfoViewProvider: Identifiable {
    let id = UUID()
    let emoji: String?
    let title: String
    let body: String
    let action: InfoViewAction?

    init(emoji: String? = nil, title: String, body: String, action: InfoViewAction? = nil) {
        self.emoji = emoji
        self.title = title
        self.body = body
        self.action = action
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
                HeadingText(self.provider.title)
                    .padding(.top, self.provider.emoji == nil ? 10 : 0)
                BodyText(self.provider.body)
                if let action = self.provider.action {
                    Button(action.label, action: action.actionBlock)
                }
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
        InfoView(
            provider: InfoViewProvider(
                title: "Info View Title",
                body: "This is the body is of an info view! It is scollable. And it is awesome and my be super long",
                action: InfoViewAction(
                    label: "Button",
                    actionBlock: {}
                )
            )
        )
    }
}
