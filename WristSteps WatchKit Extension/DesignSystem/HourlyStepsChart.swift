//
//  HourlyStepsChart.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 27.09.21.
//

import SwiftUI
import ClockKit

struct HourlyStepsChart: View {
    var body: some View {
        HStack(spacing: 0) {
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(title: "00")
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(title: "06")
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(title: "12")
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(title: "18")
            HourlyStepsClusterSpacer()
        }
    }
}

private struct HourlyStepsCluster: View {
    let title: String

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 1)
                        .offset(y: geometry.size.height)
                }
                HStack(spacing: 2) {
                    HourlyStepsBar()
                    HourlyStepsBar()
                    HourlyStepsBar()
                    HourlyStepsBar()
                    HourlyStepsBar()
                    HourlyStepsBar()
                }
                .padding([.leading, .trailing, .bottom], 2)
            }
            Body1Text(title, alignment: .leading)
                .padding(.leading, 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

private struct HourlyStepsBar: View {
    let factor = CGFloat.random(in: 0...1)

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(.orange)
                .cornerRadius(geometry.size.width / 2)
                .frame(width: geometry.size.width, height: geometry.size.height * factor)
                .offset(y: geometry.size.height * (1 - factor))
        }
    }
}

private struct HourlyStepsClusterSpacer: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(.gray)
                .frame(width: 1, height: geometry.size.height)
        }
        .frame(maxWidth: 1, maxHeight: .infinity, alignment: .bottom)
    }
}

struct HourlyStepsChart_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HourlyStepsChart()
            CLKComplicationTemplateGraphicRectangularFullView(
                HourlyStepsChart()
            ).previewContext(faceColor: .multicolor)
        }
    }
}
