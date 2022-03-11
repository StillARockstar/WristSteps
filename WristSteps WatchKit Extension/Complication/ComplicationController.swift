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
                displayName: NSLocalizedString("complication.layout.gylph", comment: ""),
                supportedFamilies: [.modularSmall, .utilitarianSmall, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.glyph.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.steps.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.steps", comment: ""),
                supportedFamilies: [.modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat , .utilitarianLarge, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.steps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.percent.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.percent", comment: ""),
                supportedFamilies: [.modularSmall, .modularLarge, .utilitarianSmall, .utilitarianSmallFlat , .utilitarianLarge, .circularSmall, .extraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.percent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.lineSteps.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.lineSteps", comment: ""),
                supportedFamilies: [.graphicCorner, .graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.lineSteps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.linePercent.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.linePercent", comment: ""),
                supportedFamilies: [.graphicCorner, .graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.linePercent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.ringSteps.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.ringSteps", comment: ""),
                supportedFamilies: [.circularSmall, .graphicCorner],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.ringSteps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.ringPercent.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.ringPercent", comment: ""),
                supportedFamilies: [.modularSmall, .utilitarianSmall, .circularSmall, .extraLarge, .graphicCorner, .graphicCircular, .graphicBezel, .graphicExtraLarge],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.ringPercent.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.ringPercentSteps.rawValue)_\(timestamp)",
                displayName: NSLocalizedString("complication.layout.ringsPercentSteps", comment: ""),
                supportedFamilies: [.graphicBezel],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.ringPercentSteps.rawValue]
            ),
            CLKComplicationDescriptor(
                identifier: "\(ComplicationProvider.ComplicationStyle.hourlySteps.rawValue)",
                displayName: NSLocalizedString("complication.layout.hourlySteps", comment: ""),
                supportedFamilies: [.graphicRectangular],
                userInfo: ["style": ComplicationProvider.ComplicationStyle.hourlySteps.rawValue]
            )
        ]
        handler(descriptors)
    }

    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.hideOnLockScreen)
    }

    // MARK: Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        #if TARGET_WATCH
        let dataProvider = AppDataProvider()
        #else
        let dataProvider = SimulatorDataProvider()
        #endif

        dataProvider.healthData.loadPersistedStepCounts()
        let complicationProvider = ComplicationProvider(dataProvider: dataProvider)
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
        let dataProvider = SampleDataProvider()

        dataProvider.healthData.loadPersistedStepCounts()
        let sampleComplicationProvider = ComplicationProvider(dataProvider: dataProvider)
        guard let styleId = complication.userInfo?["style"] as? String,
              let style = ComplicationProvider.ComplicationStyle(rawValue: styleId)
        else {
            handler(nil)
            return
        }
        handler(sampleComplicationProvider.template(for: complication.family, style: style))
    }
}
