//
//  ComplicationController.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    lazy var appComplicationProvider: ComplicationProvider = { ComplicationProvider(dataProvider: AppDataProvider()) }()
    lazy var sampleComplicationProvider: ComplicationProvider = { ComplicationProvider(dataProvider: SampleDataProvider()) }()

    // MARK: Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(
                identifier: ComplicationProvider.ComplicationStyle.glyph.rawValue,
                displayName: "Glyph",
                supportedFamilies: [.modularSmall, .utilitarianSmall, .utilitarianSmallFlat, .circularSmall, .extraLarge, .graphicCorner, .graphicCircular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.glyph.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: ComplicationProvider.ComplicationStyle.steps.rawValue,
                displayName: "Steps",
                supportedFamilies: [.modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat , .utilitarianLarge, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.steps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: ComplicationProvider.ComplicationStyle.percent.rawValue,
                displayName: "Percent",
                supportedFamilies: [.modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat , .utilitarianLarge, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.percent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: ComplicationProvider.ComplicationStyle.lineSteps.rawValue,
                displayName: "Line + Steps",
                supportedFamilies: [.graphicCorner, .graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.lineSteps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: ComplicationProvider.ComplicationStyle.linePercent.rawValue,
                displayName: "Line + Percent",
                supportedFamilies: [.graphicCorner, .graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.linePercent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: ComplicationProvider.ComplicationStyle.ringSteps.rawValue,
                displayName: "Ring + Steps",
                supportedFamilies: [.modularSmall, .utilitarianSmall, .utilitarianSmallFlat, .circularSmall, .extraLarge, .graphicCorner, .graphicCircular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.linePercent.rawValue]
            )
        ]
        handler(descriptors)
    }

    // MARK: Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        handler(nil)
    }

    // MARK: Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        guard let styleId = complication.userInfo?["style"] as? String,
              let style = ComplicationProvider.ComplicationStyle(rawValue: styleId)
        else {
            handler(nil)
            return
        }
        handler(sampleComplicationProvider.template(for: complication.family, style: style))
    }
}
