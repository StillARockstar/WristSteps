//
//  DebugMenuLogView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 28.11.21.
//

import SwiftUI
import CoreAnalytics

struct DebugMenuLogView: View {
    let message: InsightLogs.InsightMessage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("Date")
                        .font(Font.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                    Text(message.formattedDate)
                        .font(Font.system(.body, design: .monospaced))
                }
                Divider()
                Group {
                    Text("Message")
                        .font(Font.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                    Text(message.msg)
                        .font(Font.system(.body, design: .monospaced))
                }
                Divider()
                Group {
                    Text("Level")
                        .font(Font.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                    Text(message.formattedLevel)
                        .font(Font.system(.body, design: .monospaced))
                }
                Divider()
                Group {
                    Text("Tags")
                        .font(Font.system(.footnote, design: .monospaced))
                        .foregroundColor(.gray)
                    Text(message.formattedTags)
                        .font(Font.system(.body, design: .monospaced))
                }
            }
        }
    }
}
