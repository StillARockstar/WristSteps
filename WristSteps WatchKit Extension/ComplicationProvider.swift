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
        case steps = "steps"
        case percent = "percent"
        case lineSteps = "line_steps"
        case linePercent = "line_percent"
    }

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func template(for family: CLKComplicationFamily, style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch family {
        case .modularSmall:
            return modularSmallTemplate(with: style)
        case .modularLarge:
            return modularLargeTemplate(with: style)
        case .utilitarianSmall, .utilitarianSmallFlat:
            return utilitarianSmallTemplate(with: style)
        case .utilitarianLarge:
            return utilitarianLargeTemplate(with: style)
        case .circularSmall:
            return circularSmallTemplate(with: style)
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

    private func modularSmallTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: textProvider)
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func modularLargeTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let headerProvider = CLKSimpleTextProvider(text: "")
            let bodyProvider = CLKSimpleTextProvider(text: mediumStepCountString)
            return CLKComplicationTemplateModularLargeTallBody(
                headerTextProvider: headerProvider,
                bodyTextProvider: bodyProvider
            )
        case .percent:
            let headerProvider = CLKSimpleTextProvider(text: "")
            let bodyProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateModularLargeTallBody(
                headerTextProvider: headerProvider,
                bodyTextProvider: bodyProvider
            )
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func utilitarianSmallTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func utilitarianLargeTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: longStepCountString)
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: longStepPercentString)
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider)
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func circularSmallTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: textProvider)
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func extraLarge(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateExtraLargeSimpleText(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateExtraLargeSimpleText(textProvider: textProvider)
        case .lineSteps, .linePercent:
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
        case .linePercent:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsPercent)
            let textProvider = CLKSimpleTextProvider(text: longStepPercentString)
            return CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: gaugeProvider,
                outerTextProvider: textProvider
            )
        case .steps, .percent:
            return nil
        }
    }

    private func graphicRectangularTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .lineSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsPercent)
            let headerProvider = CLKSimpleTextProvider(text: "")
            let body1Provider = CLKSimpleTextProvider(text: longStepCountString)
            return CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: headerProvider,
                body1TextProvider: body1Provider,
                gaugeProvider: gaugeProvider
            )
        case .linePercent:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsPercent)
            let headerProvider = CLKSimpleTextProvider(text: "")
            let body1Provider = CLKSimpleTextProvider(text: longStepPercentString)
            return CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: headerProvider,
                body1TextProvider: body1Provider,
                gaugeProvider: gaugeProvider
            )
        case .steps, .percent:
            return nil
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

    var shortStepCountString: String {
        return "\(dataProvider.healthData.stepCount.kFormattedString)"
    }

    var mediumStepCountString: String {
        return "\(dataProvider.healthData.stepCount)"
    }

    var longStepCountString: String {
        return "\(dataProvider.healthData.stepCount) steps"
    }

    var shortStepPercentString: String {
        return "\(Int(stepsPercent))%%"
    }

    var longStepPercentString: String {
        return "\(Int(stepsPercent)) percent"
    }
}
