//
//  Metra_LiveLiveActivity.swift
//  Metra Live
//
//  Created by Benjamin Shabowski on 4/12/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Metra_LiveLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MetraLiveAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

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
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MetraLiveAttributes {
    fileprivate static var preview: MetraLiveAttributes {
        MetraLiveAttributes(name: "World")
    }
}

extension MetraLiveAttributes.ContentState {
    fileprivate static var smiley: MetraLiveAttributes.ContentState {
        MetraLiveAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MetraLiveAttributes.ContentState {
         MetraLiveAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MetraLiveAttributes.preview) {
   Metra_LiveLiveActivity()
} contentStates: {
    MetraLiveAttributes.ContentState.smiley
    MetraLiveAttributes.ContentState.starEyes
}
