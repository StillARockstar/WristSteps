//
//  DebugMenuFilesView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 26.05.21.
//

import SwiftUI

struct DebugMenuFilesView: View {
    let provider: DebugMenuViewProvider

    var body: some View {
        List(provider.loadedFileNames, id: \.self, rowContent: { filename in
            NavigationLink(
                destination: DebugMenuFileView(content: provider.content(of: filename)),
                label: {
                    VStack {
                        BodyText(filename, alignment: .leading)
//                        Body1Text(provider.lastChanged(of: filename), alignment: .leading)
                    }
                })
        })
        .onAppear(perform: {
            provider.listFiles()
        })
    }
}

struct DebugMenuFilesView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuFilesView(
            provider: DebugMenuViewProvider()
        )
    }
}
