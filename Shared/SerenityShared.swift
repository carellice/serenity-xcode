import Foundation
import ActivityKit
import AppIntents

// MARK: - Live Activity Attributes
struct SerenityActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var activeSounds: [String]
        var isPlaying: Bool
        var timerEndTime: Date?
    }
    
    var startTime: Date
}

// MARK: - App Intents
struct StopSoundsIntent: AppIntent {
    static var title: LocalizedStringResource = "Stop All Sounds"
    
    func perform() async throws -> some IntentResult {
        // Invia notifica all'app principale
        NotificationCenter.default.post(
            name: .stopAllSoundsFromWidget,
            object: nil
        )
        return .result()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let stopAllSoundsFromWidget = Notification.Name("stopAllSoundsFromWidget")
}
