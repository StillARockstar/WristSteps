//
//  BarChartView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.04.21.
//

import SwiftUI
import ClockKit

struct BarChartBarData {
    let value: Float?
}

private struct BarChartBarRenderingData: Identifiable {
    let id = UUID()
    let color: Color
    let transparent: Bool
    let valuePercent: CGFloat
}

struct BarChartView: View {
    let color: Color
    let referenceValue: Float?
    let data: [BarChartBarData]

    init(color: Color, referenceValue: Float? = nil, data: [BarChartBarData]) {
        self.color = color
        self.referenceValue = referenceValue
        self.data = data
    }

    fileprivate var referenceValuePercent: CGFloat? {
        guard let referenceValue = referenceValue else {
            return nil
        }
        let maxValue = data.map({ $0.value ?? 0 }).max() ?? .infinity
        return 1 - CGFloat(referenceValue / maxValue)
    }

    fileprivate var renderingData: [BarChartBarRenderingData] {
        let maxValue = data.map({ $0.value ?? 0 }).max() ?? .infinity
        let colorThreshold = referenceValue ?? .zero
        return data.map({ dataEntry in
            let value = dataEntry.value ?? 0
            return BarChartBarRenderingData(
                color: value >= colorThreshold ? color : .gray,
                transparent: dataEntry.value == nil,
                valuePercent: CGFloat(value / maxValue)
            )
        })
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                if let referenceValuePercent = referenceValuePercent {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                        .offset(y: geometry.size.height * referenceValuePercent)

                }
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(renderingData) { dataEntry in
                        BarChartBarView(
                            color: dataEntry.color,
                            opacity: dataEntry.transparent ? 0.5 : 1.0,
                            width: geometry.size.width / CGFloat(renderingData.count) / 3,
                            height: geometry.size.height,
                            heightPercent: dataEntry.valuePercent
                        )
                        .padding(
                            [.leading, .trailing],
                            geometry.size.width / CGFloat(renderingData.count) / 3
                        )
                    }
                }
                .frame(size: geometry.size)
            }
        }
    }
}

private struct BarChartBarView: View {
    let color: Color
    let opacity: Double
    let width: CGFloat
    let height: CGFloat
    let heightPercent: CGFloat

    var body: some View {
        VStack {
            Rectangle()
                .fill(color)
                .cornerRadius(width / 2)
                .opacity(opacity)
                .frame(
                    width: width,
                    height: max(height * heightPercent, width)
                )
        }
    }
}

private extension View {
    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height, alignment: .center)
    }
}

struct BarChartView_Previews: PreviewProvider {
    private static let previewPreferedColor: Color = AppColor.appBlue.color
    private static let previewReferenceValue: Float = 50
    private static let previewData: [BarChartBarData] = [
        BarChartBarData(value: 00),
        BarChartBarData(value: 10),
        BarChartBarData(value: 20),
        BarChartBarData(value: 30),
        BarChartBarData(value: 40),
        BarChartBarData(value: 50),
        BarChartBarData(value: 60),
        BarChartBarData(value: 70),
        BarChartBarData(value: 80),
        BarChartBarData(value: 90)
    ]

    static var previews: some View {
        Group {
            BarChartView(
                color: Self.previewPreferedColor,
                referenceValue: Self.previewReferenceValue,
                data: Self.previewData
            )
            CLKComplicationTemplateGraphicRectangularFullView(
                BarChartView(
                    color: Self.previewPreferedColor,
                    referenceValue: Self.previewReferenceValue,
                    data: Self.previewData
                )
            ).previewContext(faceColor: .multicolor)
            CLKComplicationTemplateGraphicRectangularFullView(
                BarChartView(
                    color: Self.previewPreferedColor,
                    referenceValue: Self.previewReferenceValue,
                    data: Self.previewData
                )
            ).previewContext(faceColor: .green)
        }
    }
}
