//
//  HomeView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import SwiftUI

enum HomeViewSheetItemType: Identifiable {
    case setGoal
    case setColor
    case info

    var id: Int { hashValue }
}

struct HomeView: View {
    @State var sheetItem: HomeViewSheetItemType?
    @EnvironmentObject var provider: HomeViewProvider

    var body: some View {
        VStack {
            Spacer()
            DetailView(
                stepCount: provider.stepCount,
                stepGoal: provider.stepGoal
            )
            Spacer()
            HStack {
                Button("🏁", action: {
                    sheetItem = .setGoal
                })
                Button("🎨", action: {
                    sheetItem = .setColor
                })
            }
        }
        .onLongPressGesture {
            sheetItem = .info
        }
        .sheet(item: $sheetItem, content: { item -> AnyView in
            switch item {
            case .setGoal:
                return SetGoalView()
                    .environmentObject(provider.setGoalViewProvider)
                    .asAnyView()
            case .setColor:
                return SetColorView()
                    .environmentObject(provider.setColorViewProvider)
                    .asAnyView()
            case .info:
                return InfoView().asAnyView()
            }
        })
        .navigationBarTitle("WristSteps")

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(HomeViewProvider(dataProvider: SimulatorDataProvider()))
    }
}
