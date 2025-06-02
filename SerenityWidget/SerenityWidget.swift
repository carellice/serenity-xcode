import WidgetKit
import SwiftUI
import ActivityKit

// MARK: - Widget Bundle
@main
struct SerenityWidgetBundle: WidgetBundle {
    var body: some Widget {
        SerenityLiveActivity()
    }
}

// MARK: - Live Activity
struct SerenityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SerenityActivityAttributes.self) { context in
            // Lock Screen View
            LockScreenView(context: context)
                .activityBackgroundTint(Color(red: 0.1, green: 0.1, blue: 0.1))
                .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded regions
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Spacer()
                        Label("Serenity", systemImage: "moon.zzz.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            if let endTime = context.state.timerEndTime {
                                TimerView(endTime: endTime)
                            } else {
                                Text("No Timer")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        if context.state.activeSounds.isEmpty {
                            Text("No sounds playing")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text(context.state.activeSounds.joined(separator: " • "))
                                .font(.caption)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    EmptyView()
                }
            } compactLeading: {
                Image(systemName: "moon.zzz.fill")
                    .font(.caption)
                    .foregroundColor(.white)
            } compactTrailing: {
                Image(systemName: context.state.isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.caption)
                    .foregroundColor(context.state.isPlaying ? .green : .gray)
            } minimal: {
                Image(systemName: "moon.zzz.fill")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .keylineTint(Color.white.opacity(0.7))
        }
    }
}

// MARK: - Lock Screen View
struct LockScreenView: View {
    let context: ActivityViewContext<SerenityActivityAttributes>
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Label("Serenity", systemImage: "moon.zzz.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                
                if !context.state.activeSounds.isEmpty {
                    Text(context.state.activeSounds.joined(separator: " • "))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            
            Spacer()
            
            if let endTime = context.state.timerEndTime {
                TimerView(endTime: endTime)
            }
        }
        .padding()
    }
}

// MARK: - Timer View
struct TimerView: View {
    let endTime: Date
    
    var body: some View {
        Text(endTime, style: .timer)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .foregroundColor(.orange)
            .monospacedDigit()
    }
}
