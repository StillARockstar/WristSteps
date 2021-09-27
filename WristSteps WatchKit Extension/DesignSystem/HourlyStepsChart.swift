//
//  HourlyStepsChart.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 27.09.21.
//

import SwiftUI
import ClockKit

struct HourlyStepsBarData {
    let value: Float?
}

private struct HourlyStepsClusterRenderingData {
    let title: String
}

private struct HourlyStepsRenderingData {
    let color: Color
    let transparent: Bool
    let valuePercent: CGFloat
}

struct HourlyStepsChartData {
    fileprivate let clusterData: [HourlyStepsClusterRenderingData]

    init?(data: [HourlyStepsBarData]) {
        guard data.count == 24 else {
            return nil
        }
        var clusterData = [HourlyStepsClusterRenderingData]()
        clusterData.append(HourlyStepsClusterRenderingData(title: "00"))
        clusterData.append(HourlyStepsClusterRenderingData(title: "06"))
        clusterData.append(HourlyStepsClusterRenderingData(title: "12"))
        clusterData.append(HourlyStepsClusterRenderingData(title: "18"))
        self.clusterData = clusterData
    }
}

struct HourlyStepsChart: View {
    let chartData: HourlyStepsChartData

    init(chartData: HourlyStepsChartData) {
        self.chartData = chartData
    }

    var body: some View {
        HStack(spacing: 0) {
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(renderingData: chartData.clusterData[0])
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(renderingData: chartData.clusterData[1])
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(renderingData: chartData.clusterData[2])
            HourlyStepsClusterSpacer()
            HourlyStepsCluster(renderingData: chartData.clusterData[3])
            HourlyStepsClusterSpacer()
        }
    }
}

private struct HourlyStepsCluster: View {
    let renderingData: HourlyStepsClusterRenderingData

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
            Body1Text(renderingData.title, alignment: .leading)
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
            HourlyStepsChart(
                chartData: HourlyStepsChartData(
                    data: [HourlyStepsBarData].init(repeating: HourlyStepsBarData(value: 0.0), count: 24)
                )!
            )
            CLKComplicationTemplateGraphicRectangularFullView(
                HourlyStepsChart(
                    chartData: HourlyStepsChartData(
                        data: [HourlyStepsBarData].init(repeating: HourlyStepsBarData(value: 0.0), count: 24)
                    )!
                )
            ).previewContext(faceColor: .multicolor)
        }
    }
}
