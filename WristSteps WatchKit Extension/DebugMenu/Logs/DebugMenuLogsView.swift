//
//  DebugMenuLogsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 28.11.21.
//

import SwiftUI
import CoreAnalytics
import CoreInsightsShared

struct DebugMenuLogsView: View {
    @ObservedObject var provider: DebugMenuViewProvider

    var body: some View {
        ScrollView {
            HStack {
                NavigationLink(
                    destination: {
                        DebugMenuLogsLevelsView(provider: provider)
                    },
                    label: {
                        Text("Levels")
                    }
                )
                NavigationLink(
                    destination: {
                        DebugMenuLogsTagsView(provider: provider)
                    },
                    label: {
                        Text("Tags")
                    }
                )
            }
            VStack {
                ForEach(provider.filteredLogs, id: \.id, content: { logMessage in
                    DebugMenuMessageView(message: logMessage)
                })
                if provider.moreLogsAvailabe {
                    Button("Load More", action: {
                        provider.loadMoreLogs()
                    })
                }
            }
            .onAppear(perform: {
                provider.loadLogs()
            })
        }
    }
}

struct DebugMenuMessageView: View {
    let message: LogMessage

    var body: some View {
        NavigationLink(
            destination: {
                DebugMenuLogView(message: message)
            },
            label: {
                VStack(alignment: .leading) {
                    Text(message.formattedDate)
                        .font(Font.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                    Text(message.text)
                        .font(Font.system(.caption2, design: .monospaced))
                        .multilineTextAlignment(.leading)
                }
            }
        )
    }
}

struct DebugMenuLogsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuLogsView(provider: DebugMenuViewProvider())
    }
}
