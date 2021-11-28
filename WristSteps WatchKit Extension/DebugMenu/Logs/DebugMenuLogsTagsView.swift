//
//  DebugMenuLogsTagsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 28.11.21.
//

import SwiftUI

struct DebugMenuLogsTagsView: View {
    @ObservedObject var provider: DebugMenuViewProvider

    var body: some View {
        ScrollView {
            VStack {
                ForEach(provider.availableTags(), id: \.self, content: { tag in
                    Button(
                        action: {
                            provider.toggleTagFilter(tag)
                        },
                        label: {
                            HStack {
                                if provider.shownTags?.contains(tag) ?? false {
                                    Text("✅ \(tag)")
                                } else {
                                    Text("🔲 \(tag)")
                                }
                                Spacer()
                            }
                        }
                    )
                })
            }
        }
    }
}

struct DebugMenuLogsTagsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuLogsTagsView(provider: DebugMenuViewProvider())
    }
}
