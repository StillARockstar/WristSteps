//
//  DebugMenuFileView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 26.05.21.
//

import SwiftUI

struct DebugMenuFileView: View {
    let content: String

    var body: some View {
        ScrollView {
            Text(content)
                .lineLimit(nil)
                .font(Font.system(.caption2, design: .monospaced))
        }
    }
}

struct DebugMenuFileView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuFileView(content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse est leo, vehicula eu eleifend non, auctor ut arcu")
    }
}
