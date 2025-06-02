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
    static var openAppWhenRun: Bool = true  // Cambiato a true per aprire l'app
    
    func perform() async throws -> some IntentResult {
        // Usa UserDefaults con App Group per comunicare
        if let userDefaults = UserDefaults(suiteName: "group.com.tuonome.serenity") {
            userDefaults.set(true, forKey: "shouldStopAllSounds")
            userDefaults.set(Date().timeIntervalSince1970, forKey: "stopRequestTime")
        }
        
        return .result()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let stopAllSoundsFromWidget = Notification.Name("stopAllSoundsFromWidget")
}
