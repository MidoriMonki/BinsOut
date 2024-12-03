//
//  BinsOutWidgetLiveActivity.swift
//  BinsOutWidget
//
//  Created by Zac Murray on 28/3/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BinsOutWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BinsOutWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.1, *) {
            ActivityConfiguration(for: BinsOutWidgetAttributes.self) { context in
                // Lock screen/banner UI goes here
                if #available(iOSApplicationExtension 16.0, *) {
                    VStack {
                        Text("Hello")
                    }
                    .activityBackgroundTint(Color.cyan)
                    .activitySystemActionForegroundColor(Color.black)
                } else {
                    // Fallback on earlier versions
                }
                
            } dynamicIsland: { context in
                DynamicIsland {
                    // Expanded UI goes here.  Compose the expanded UI through
                    // various regions, like leading/trailing/center/bottom
                    DynamicIslandExpandedRegion(.leading) {
                        Text("Leading")
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        Text("Trailing")
                    }
                    DynamicIslandExpandedRegion(.bottom) {
                        Text("Bottom")
                        // more content
                    }
                } compactLeading: {
                    Text("L")
                } compactTrailing: {
                    Text("T")
                } minimal: {
                    Text("Min")
                }
                .widgetURL(URL(string: "http://www.apple.com"))
                .keylineTint(Color.red)
            }
        } else {
            // Fallback on earlier versions
        }
        return EmptyWidgetConfiguration() //(any WidgetConfiguration)()
    }
}
