//
//  ComplicationProvider.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 05.09.20.
//

import ClockKit
import SwiftUI

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
        case ringPercentSteps = "ring_percent_steps"
        case hourlySteps = "hourly_steps"
    }

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    func template(for family: CLKComplicationFamily, style: ComplicationStyle) -> CLKComplicationTemplate? {
        var template: CLKComplicationTemplate?
        switch family {
        case .modularSmall:
            template = modularSmallTemplate(with: style)
        case .modularLarge:
            template = modularLargeTemplate(with: style)
        case .utilitarianSmall:
            template = utilitarianSmallTemplate(with: style)
        case .utilitarianSmallFlat:
            template = utilitarianSmallFlatTemplate(with: style)
        case .utilitarianLarge:
            template = utilitarianLargeTemplate(with: style)
        case .circularSmall:
            template = circularSmallTemplate(with: style)
        case .extraLarge:
            template = extraLarge(with: style)
        case .graphicCorner:
            template = graphicCornerTemplate(with: style)
        case .graphicBezel:
            template = graphicBezelTemplate(with: style)
        case .graphicCircular:
            template = graphicCircularTemplate(with: style)
        case .graphicRectangular:
            template = graphicRectangularTemplate(with: style)
        case .graphicExtraLarge:
            template = graphicExtraLargeTemplate(with: style)
        @unknown default:
            return nil
        }
        if template?.acceptsUniversalTint ?? true {
            template?.tintColor = color
        }
        return template
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
            let textProvider = CLKSimpleTextProvider(text: mediumStepPercentString)
            return CLKComplicationTemplateModularSmallSimpleText(textProvider: textProvider)
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateModularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsFraction,
                ringStyle: .closed
            )
        case .lineSteps, .linePercent, .ringSteps, .ringPercentSteps, .hourlySteps:
            return nil
        }
    }

    private func modularLargeTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let headerProvider = CLKSimpleTextProvider(
                text: NSLocalizedString("complication.content.modularLarge.stepsToday", comment: "")
            )
            let bodyProvider = CLKSimpleTextProvider(text: mediumStepCountString)
            return CLKComplicationTemplateModularLargeTallBody(
                headerTextProvider: headerProvider,
                bodyTextProvider: bodyProvider
            )
        case .percent:
            let headerProvider = CLKSimpleTextProvider(
                text: NSLocalizedString("complication.content.modularLarge.goalToday", comment: "")
            )
            let bodyProvider = CLKSimpleTextProvider(text: mediumStepPercentString)
            return CLKComplicationTemplateModularLargeTallBody(
                headerTextProvider: headerProvider,
                bodyTextProvider: bodyProvider
            )
        case .glyph, .lineSteps, .linePercent, .ringSteps, .ringPercent, .ringPercentSteps, .hourlySteps:
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
            let textProvider = CLKSimpleTextProvider(text: mediumStepPercentString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateUtilitarianSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsFraction,
                ringStyle: .closed
            )
        case .lineSteps, .linePercent, .ringSteps, .ringPercentSteps, .hourlySteps:
            return nil
        }
    }

    private func utilitarianSmallFlatTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .steps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .percent:
            let textProvider = CLKSimpleTextProvider(text: mediumStepPercentString)
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider)
        case .glyph, .lineSteps, .linePercent, .ringSteps, .ringPercent, .ringPercentSteps, .hourlySteps:
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
        case .glyph, .lineSteps, .linePercent, .ringSteps, .ringPercent, .ringPercentSteps, .hourlySteps:
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
            let textProvider = CLKSimpleTextProvider(text: mediumStepPercentString)
            return CLKComplicationTemplateCircularSmallSimpleText(textProvider: textProvider)
        case .ringSteps:
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateCircularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsFraction,
                ringStyle: .closed
            )
        case .ringPercent:
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateCircularSmallRingText(
                textProvider: textProvider,
                fillFraction: stepsFraction,
                ringStyle: .closed
            )
        case .lineSteps, .linePercent, .ringPercentSteps, .hourlySteps:
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
        case .lineSteps, .linePercent, .ringSteps, .ringPercent, .ringPercentSteps, .hourlySteps:
            return nil
        }
    }

    private func graphicCornerTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .lineSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let textProvider = CLKSimpleTextProvider(text: mediumStepCountString)
            return CLKComplicationTemplateGraphicCornerGaugeText(
                gaugeProvider: gaugeProvider,
                outerTextProvider: textProvider
            )
        case .linePercent:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let textProvider = CLKSimpleTextProvider(text: mediumStepPercentString)
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
        case .glyph, .steps, .percent, .ringPercentSteps, .hourlySteps:
            return nil
        }
    }

    private func graphicBezelTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .ringPercent:
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: graphicCircularTemplate(with: style) as! CLKComplicationTemplateGraphicCircular,
                textProvider: nil
            )
        case .ringPercentSteps:
            let textProvider = CLKSimpleTextProvider(text: longStepCountString)
            return CLKComplicationTemplateGraphicBezelCircularText(
                circularTemplate: graphicCircularTemplate(with: .ringPercent) as! CLKComplicationTemplateGraphicCircular,
                textProvider: textProvider
            )
        case .glyph, .steps, .percent, .lineSteps, .linePercent, .ringSteps, .hourlySteps:
            return nil
        }
    }

    private func graphicCircularTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .ringPercent:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateGraphicCircularClosedGaugeText(
                gaugeProvider: gaugeProvider,
                centerTextProvider: textProvider
            )
        case .glyph, .steps, .percent, .lineSteps, .linePercent, .ringSteps, .ringPercentSteps, .hourlySteps:
            return nil
        }
    }

    private func graphicRectangularTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .lineSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let headerProvider = CLKSimpleTextProvider(text: "")
            let body1Provider = CLKSimpleTextProvider(text: longStepCountString)
            return CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: headerProvider,
                body1TextProvider: body1Provider,
                gaugeProvider: gaugeProvider
            )
        case .linePercent:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let headerProvider = CLKSimpleTextProvider(text: "")
            let body1Provider = CLKSimpleTextProvider(text: longStepPercentString)
            return CLKComplicationTemplateGraphicRectangularTextGauge(
                headerTextProvider: headerProvider,
                body1TextProvider: body1Provider,
                gaugeProvider: gaugeProvider
            )
        case .hourlySteps:
            let headerProvider = CLKSimpleTextProvider(text: longStepCountString)
            headerProvider.tintColor = .white
            let template = CLKComplicationTemplateGraphicRectangularLargeView(
                headerTextProvider: headerProvider,
                content: hourlyStepsView
            )
            template.acceptsUniversalTint = false
            return template
        case .glyph, .steps, .percent, .ringSteps, .ringPercent, .ringPercentSteps:
            return nil
        }
    }

    private func graphicExtraLargeTemplate(with style: ComplicationStyle) -> CLKComplicationTemplate? {
        switch style {
        case .ringSteps:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let textProvider = CLKSimpleTextProvider(text: shortStepCountString)
            return CLKComplicationTemplateGraphicExtraLargeCircularClosedGaugeText(
                gaugeProvider: gaugeProvider,
                centerTextProvider: textProvider
            )
        case .ringPercent:
            let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: color, fillFraction: stepsFraction)
            let textProvider = CLKSimpleTextProvider(text: shortStepPercentString)
            return CLKComplicationTemplateGraphicExtraLargeCircularClosedGaugeText(
                gaugeProvider: gaugeProvider,
                centerTextProvider: textProvider
            )
        case .glyph, .steps, .percent, .lineSteps, .linePercent, .ringPercentSteps, .hourlySteps:
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
        return UIImage(named: "app_glyph")!.imageWithColor(newColor: color)
    }

    var percentImage: UIImage {
        var stepPercent = Int(stepsPercent)

        if stepPercent > 100 {
            stepPercent = stepPercent % 100 + 100
        }

        return UIImage(named:"radialGraph\(stepPercent)")!.imageWithColor(newColor: color)
    }

    var stepsFraction: Float {
        let stepCount = dataProvider.healthData.stepCount
        let stepGoal = dataProvider.userData.stepGoal
        return Float(stepCount) / Float(stepGoal)
    }

    var stepsPercent: Float {
        let stepPercent = Int(stepsFraction * 100)

        return Float(stepPercent)
    }

    var shortStepCountString: String {
        return "\(dataProvider.healthData.stepCount.kFormattedString)"
    }

    var mediumStepCountString: String {
        return "\(dataProvider.healthData.stepCount)"
    }

    var longStepCountString: String {
        return String(
            format: NSLocalizedString("complication.content.steps", comment: ""),
            "\(dataProvider.healthData.stepCount)"
        )
    }

    var shortStepPercentString: String {
        return "\(Int(stepsPercent))"
    }

    var mediumStepPercentString: String {
        return "\(Int(stepsPercent))%"
    }

    var longStepPercentString: String {
        return String(
            format: NSLocalizedString("complication.content.percent", comment: ""),
            "\(Int(stepsPercent))"
        )
    }

    var hourlyStepsView: some View {
        let chartData = HourlyStepsChartData(
            color: AppColor.color(forName: dataProvider.userData.colorName).color,
            data: dataProvider.healthData.hourlyStepCounts.map({ HourlyStepsBarData(value: Float($0)) })
        )
        return HourlyStepsChart(chartData: chartData)
    }
}

extension CLKComplicationTemplate {
    static var _acceptsUniversalTint: Bool = true

    /// Indicates if the generic tint should be applied to the Template. This value is false, if the tint is handled by the Template individually
    var acceptsUniversalTint: Bool {
        get {
            return Self._acceptsUniversalTint
        }
        set {
            Self._acceptsUniversalTint = newValue
        }
    }
}

