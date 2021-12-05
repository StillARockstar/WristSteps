//
//  DebugMenuLogsLevelsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 28.11.21.
//

import SwiftUI

struct DebugMenuLogsLevelsView: View {
    @ObservedObject var provider: DebugMenuViewProvider

    var body: some View {
        ScrollView {
            VStack {
                ForEach(provider.availableLogLevels(), id: \.self, content: { level in
                    Button(
                        action: {
                            provider.toggleLogFilter(level)
                        },
                        label: {
                            HStack {
                                if provider.shownLevels.contains(level) {
                                    Text("✅ \(level.formatted)")
                                } else {
                                    Text("🔲 \(level.formatted)")
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

struct DebugMenuLogsLevelsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuLogsLevelsView(provider: DebugMenuViewProvider())
    }
}
