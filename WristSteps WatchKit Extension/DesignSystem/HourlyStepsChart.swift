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
    let renderingData: [HourlyStepsRenderingData]
}

private struct HourlyStepsRenderingData: Identifiable {
    let id = UUID()
    let valuePercent: CGFloat
}

struct HourlyStepsChartData {
    fileprivate let clusterData: [HourlyStepsClusterRenderingData]

    init?(data: [HourlyStepsBarData]) {
        guard data.count == 24 else {
            return nil
        }

        let maxValue = data.map({ $0.value ?? 0 }).max() ?? .infinity
        let renderingData = data.map({ dataEntry -> HourlyStepsRenderingData in
            let value = dataEntry.value ?? 0
            return HourlyStepsRenderingData(
                valuePercent: maxValue > 0 ? CGFloat(value / maxValue) : 0.0
            )
        })

        var clusterData = [HourlyStepsClusterRenderingData]()
        clusterData.append(HourlyStepsClusterRenderingData(
            title: "00",
            renderingData: Array(renderingData[0..<6])
        ))
        clusterData.append(HourlyStepsClusterRenderingData(
            title: "06",
            renderingData: Array(renderingData[6..<12])
        ))
        clusterData.append(HourlyStepsClusterRenderingData(
            title: "12",
            renderingData: Array(renderingData[12..<18])
        ))
        clusterData.append(HourlyStepsClusterRenderingData(
            title: "18",
            renderingData: Array(renderingData[18..<24])
        ))
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
                    ForEach(renderingData.renderingData, content: {
                        HourlyStepsBar(valuePercent: $0.valuePercent)
                    })
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
    let valuePercent: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let height = max(geometry.size.height * valuePercent, geometry.size.width)
            Rectangle()
                .fill(.orange)
                .cornerRadius(geometry.size.width / 2)
                .frame(width: geometry.size.width, height: height)
                .offset(y: geometry.size.height - height)
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
    private static let previewData: [HourlyStepsBarData] = [
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: nil),
        HourlyStepsBarData(value: 00),
        HourlyStepsBarData(value: 01),
        HourlyStepsBarData(value: 02),
        HourlyStepsBarData(value: 03),
        HourlyStepsBarData(value: 04),
        HourlyStepsBarData(value: 05),
        HourlyStepsBarData(value: 06),
        HourlyStepsBarData(value: 07),
        HourlyStepsBarData(value: 08),
        HourlyStepsBarData(value: 09),
        HourlyStepsBarData(value: 10),
        HourlyStepsBarData(value: 11),
        HourlyStepsBarData(value: 12)
    ]

    static var previews: some View {
        Group {
            HourlyStepsChart(chartData: HourlyStepsChartData(data: Self.previewData)!)
            CLKComplicationTemplateGraphicRectangularFullView(
                HourlyStepsChart(chartData: HourlyStepsChartData(data: Self.previewData)!)
            ).previewContext(faceColor: .multicolor)
        }
    }
}
