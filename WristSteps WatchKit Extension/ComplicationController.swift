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
