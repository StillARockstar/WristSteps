//
//  DebugMenuView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 23.05.21.
//

import SwiftUI

struct DebugMenuView: View {
    @State private var showingResetAlert = false

    var body: some View {
        VStack {
            NavigationLink("Files", destination: DebugMenuView())
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
                            print("Reset")
                        }),
                    secondaryButton:
                        .cancel()
                )
            }
            .foregroundColor(.red)
            Spacer()
        }
        .embedInNavigation()
    }
}

struct DebugMenuView_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenuView()
    }
}
