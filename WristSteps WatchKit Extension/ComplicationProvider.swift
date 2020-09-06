//
//  ComplicationProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 05.09.20.
//

import ClockKit

class ComplicationProvider {
    private let dataProvider: DataProvider

    enum ComplicationStyle: String {
        case lineSteps = "line_steps"
    }

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func template(for family: CLKComplicationFamily, style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch family {
        case .modularSmall:
            return nil
        case .modularLarge:
            return nil
        case .utilitarianSmall:
            return nil
        case .utilitarianSmallFlat:
            return nil
        case .utilitarianLarge:
            return nil
        case .circularSmall:
            return nil
        case .extraLarge:
            return nil
        case .graphicCorner:
            return graphicCornerTemplate(with: style)
        case .graphicBezel:
            return nil
        case .graphicCircular:
            return nil
        case .graphicRectangular:
            return graphicRectangularTemplate(with: style)
        case .graphicExtraLarge:
            return nil
        @unknown default:
            return nil
        }
    }

    private func graphicCornerTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .lineSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsPercent)
            let textProvider = CLKSimpleTextProvider(text: longStepCountString)
            return CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: gaugeProvider,
                outerTextProvider: textProvider
            )
        }
    }

    private func graphicRectangularTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate {
        switch style {
        case .lineSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsPercent)
            let headerProvider = CLKSimpleTextProvider(text: "WristSteps")
            let body1Provider = CLKSimpleTextProvider(text: longStepCountString)
            return CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: headerProvider,
                body1TextProvider: body1Provider,
                gaugeProvider: gaugeProvider
            )
        }
    }
}

private extension ComplicationProvider {
    var color: UIColor {
        let appColor = AppColor.color(forName: dataProvider.userData.colorName)
        return UIColor(appColor.color)
    }

    var stepsPercent: Float {
        let stepCount = dataProvider.healthData.stepCount
        let stepGoal = dataProvider.userData.stepGoal

        let calculatedPercent = Double(stepCount) / Double(stepGoal)
        let stepPercent = Int(calculatedPercent * 100)

        return Float(stepPercent)
    }

    var longStepCountString: String {
        return "\(dataProvider.healthData.stepCount) steps"
    }
}
