//
//  ComplicationController.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 30.08.20.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let timestamp = Date().timeIntervalSince1970
        let descriptors = [
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.glyph.rawValue)_\(timestamp)",
                displayName: "Glyph",
                supportedFamilies: [.modularSmall, .utilitarianSmall, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.glyph.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.steps.rawValue)_\(timestamp)",
                displayName: "Steps",
                supportedFamilies: [.modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat , .utilitarianLarge, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.steps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.percent.rawValue)_\(timestamp)",
                displayName: "Percent",
                supportedFamilies: [.modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat , .utilitarianLarge, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.percent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.lineSteps.rawValue)_\(timestamp)",
                displayName: "Line + Steps",
                supportedFamilies: [.graphicCorner, .graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.lineSteps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.linePercent.rawValue)_\(timestamp)",
                displayName: "Line + Percent",
                supportedFamilies: [.graphicCorner, .graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.linePercent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.ringSteps.rawValue)_\(timestamp)",
                displayName: "Ring + Steps",
                supportedFamilies: [.modularSmall, .utilitarianSmall, .circularSmall, .extraLarge, .graphicCorner, .graphicCircular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.ringSteps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.ringPercent.rawValue)_\(timestamp)",
                displayName: "Ring + Percent",
                supportedFamilies: [.modularSmall, .utilitarianSmall, .circularSmall, .extraLarge, .graphicCorner, .graphicCircular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.ringPercent.rawValue]
            )
        ]
        handler(descriptors)
    }

    // MARK: Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        #if TARGET_WATCH
        let complicationProvider = ComplicationProvider(dataProvider: AppDataProvider())
        #else
        let complicationProvider = ComplicationProvider(dataProvider: SampleDataProvider())
        #endif
        guard let styleId = complication.userInfo?["style"] as? String,
              let style = ComplicationProvider.ComplicationStyle(rawValue: styleId)
        else {
            handler(nil)
            return
        }
        guard let complicationTemplate = complicationProvider.template(for: complication.family, style: style) else {
            handler(nil)
            return
        }

        let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: complicationTemplate)
        handler(timelineEntry)
    }

    // MARK: Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let sampleComplicationProvider = ComplicationProvider(dataProvider: SampleDataProvider())
        guard let styleId = complication.userInfo?["style"] as? String,
              let style = ComplicationProvider.ComplicationStyle(rawValue: styleId)
        else {
            handler(nil)
            return
        }
        handler(sampleComplicationProvider.template(for: complication.family, style: style))
    }
}
