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
        case glyph = "glyph"
        case steps = "steps"
        case percent = "percent"
        case lineSteps = "line_steps"
        case linePercent = "line_percent"
        case ringSteps = "ring_steps"
        case ringPercent = "ring_percent"
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
            return extraLarge(with: style)
        case .graphicCorner:
            return graphicCornerTemplate(with: style)
        case .graphicBezel:
            return nil
        case .graphicCircular:
            return graphicCircularTemplate(with: style)
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
        case .glyph:
            let imageProvider = CLKImageProvider(onePieceImage: appGlyph)
            imageProvider.tintColor = color
            return CLKComplicationTemplateModularSmallSimpleImage(imageProvider: imageProvider)
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: textProvider)
        case .ringSteps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateModularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateModularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
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
        case .glyph, .lineSteps, .linePercent, .ringSteps, .ringPercent:
            return nil
        }
    }

    private func utilitarianSmallTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .glyph:
            let imageProvider = CLKImageProvider(onePieceImage: appGlyph)
            imageProvider.tintColor = color
            return CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: imageProvider)
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .ringSteps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateUtilitarianSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateUtilitarianSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
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
        case .glyph, .lineSteps, .linePercent, .ringSteps, .ringPercent:
            return nil
        }
    }

    private func circularSmallTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .glyph:
            let imageProvider = CLKImageProvider(onePieceImage: appGlyph)
            imageProvider.tintColor = color
            return CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: imageProvider)
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: textProvider)
        case .ringSteps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateCircularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateCircularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func extraLarge(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .glyph:
            let imageProvider = CLKImageProvider(onePieceImage: appGlyph)
            imageProvider.tintColor = color
            return CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: imageProvider)
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateExtraLargeSimpleText(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateExtraLargeSimpleText(textProvider: textProvider)
        case .ringSteps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateExtraLargeRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateExtraLargeRingText(
                textProvider: textProvider,
                fillFraction: stepsPercent,
                ringStyle: .closed
            )
        case .lineSteps, .linePercent:
            return nil
        }
    }

    private func graphicCornerTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .glyph:
            let imageProvider = CLKFullColorImageProvider(fullColorImage: appGlyph)
            return CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: imageProvider)
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
        case .ringSteps:
            let textProvider = CLKSimpleTextProvider(text: longStepCountString)
            let imageProvider = CLKFullColorImageProvider(fullColorImage: percentImage)
            return CLKComplicationTemplateGraphicCornerTextImage(textProvider: textProvider, imageProvider: imageProvider)
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: longStepPercentString)
            let imageProvider = CLKFullColorImageProvider(fullColorImage: percentImage)
            return CLKComplicationTemplateGraphicCornerTextImage(textProvider: textProvider, imageProvider: imageProvider)
        case .steps, .percent:
            return nil
        }
    }

    private func graphicCircularTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .glyph:
            let imageProvider = CLKFullColorImageProvider(fullColorImage: appGlyph)
            return CLKComplicationTemplateGraphicCircularImage(imageProvider: imageProvider)
        case .ringSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsPercent)
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: gaugeProvider,
                centerTextProvider: textProvider
            )
        case .steps, .percent, .lineSteps, .linePercent, .ringPercent:
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
        case .glyph, .steps, .percent, .ringSteps, .ringPercent:
            return nil
        }
    }
}

private extension ComplicationProvider {
    var color: UIColor {
        let appColor = AppColor.color(forName: dataProvider.userData.colorName)
        return UIColor(appColor.color)
    }

    var appGlyph: UIImage {
        return UIImage(named: "app_glyph")!
    }

    var percentImage: UIImage {
        var stepPercent = Int(stepsPercent)

        if stepPercent > 100 {
            stepPercent = stepPercent % 100 + 100
        }

        return UIImage(named:"radialGraph\(stepPercent)")!
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
