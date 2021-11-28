//
//  DebugMenuLogsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 28.11.21.
//

import SwiftUI
import CoreAnalytics

struct DebugMenuLogsView: View {
    @ObservedObject var provider: DebugMenuViewProvider

    var body: some View {
        ScrollView {
            VStack {
                ForEach(provider.loadedLogs, id: \.id, content: { logMessage in
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
    let message: InsightLogs.InsightMessage

    var body: some View {
        Button(
            action: {},
            label: {
                VStack(alignment: .leading) {
                    Text(message.formattedDate)
                        .font(Font.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                    Text(message.msg)
                        .font(Font.system(.caption2, design: .monospaced))
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
