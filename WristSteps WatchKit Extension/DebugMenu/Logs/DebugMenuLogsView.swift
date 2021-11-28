//
//  DebugMenuLogsView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 28.11.21.
//

import SwiftUI

struct DebugMenuLogsView: View {
    @ObservedObject var provider: DebugMenuViewProvider

    var body: some View {
        VStack {
            Text("Number of Logs: \(provider.loadedLogs.count)")
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

struct DebugMenuLogsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuLogsView(provider: DebugMenuViewProvider())
    }
}
