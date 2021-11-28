//
//  DebugMenuView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import SwiftUI

struct DebugMenuView: View {
    @ObservedObject var provider: DebugMenuViewProvider
    @State private var showingResetAlert = false

    var body: some View {
        List {
            Section(content: {
                NavigationLink(
                    "Files",
                    destination: DebugMenuFilesView(provider: provider)
                )
                Button("Reset App", action: {
                    showingResetAlert = true
                })
                .alert(isPresented: $showingResetAlert) {
                    Alert(
                        title: Text("Reset App"),
                        message: Text("Delete all data and restart"),
                        primaryButton: .destructive(
                            Text("Reset"),
                            action: {
                                provider.resetApp()
                            }),
                        secondaryButton:
                            .cancel()
                    )
                }
                .foregroundColor(.red)
            })
        }
        .embedInNavigation()
    }
}

struct DebugMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuView(
            provider: DebugMenuViewProvider()
        )
    }
}
