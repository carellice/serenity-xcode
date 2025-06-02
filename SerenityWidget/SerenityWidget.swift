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
                            .foregroundColor(.blue)
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
                    Button(intent: StopSoundsIntent()) {
                        Label("Stop All", systemImage: "stop.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
            } compactLeading: {
                Image(systemName: "moon.zzz.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
            } compactTrailing: {
                Image(systemName: context.state.isPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                    .font(.caption)
                    .foregroundColor(context.state.isPlaying ? .green : .gray)
            } minimal: {
                Image(systemName: "moon.zzz.fill")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .keylineTint(Color.blue)
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
                
                if !context.state.activeSounds.isEmpty {
                    Text(context.state.activeSounds.joined(separator: " • "))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let endTime = context.state.timerEndTime {
                TimerView(endTime: endTime)
                    .padding(.trailing)
            }
            
            Button(intent: StopSoundsIntent()) {
                Image(systemName: "stop.circle.fill")
                    .font(.title2)
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
