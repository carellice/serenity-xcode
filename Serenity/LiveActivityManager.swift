import Foundation
import ActivityKit

class LiveActivityManager {
    static let shared = LiveActivityManager()
    private var currentActivity: Activity<SerenityActivityAttributes>?
    
    private init() {}
    
    // Avvia o aggiorna la Live Activity
    func startOrUpdateActivity(activeSounds: [String], isPlaying: Bool, timerEndTime: Date?) {
        print("LiveActivityManager: Updating with sounds: \(activeSounds), playing: \(isPlaying)")
        
        let attributes = SerenityActivityAttributes(startTime: Date())
        let contentState = SerenityActivityAttributes.ContentState(
            activeSounds: activeSounds,
            isPlaying: isPlaying,
            timerEndTime: timerEndTime
        )
        
        Task { @MainActor in
            if let currentActivity = currentActivity {
                // Aggiorna l'activity esistente
                await currentActivity.update(using: contentState)
                print("Live Activity updated")
            } else {
                // Crea una nuova activity
                do {
                    let activity = try Activity.request(
                        attributes: attributes,
                        contentState: contentState,
                        pushType: nil
                    )
                    self.currentActivity = activity
                    print("Live Activity started with ID: \(activity.id)")
                } catch {
                    print("Error starting Live Activity: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Ferma la Live Activity
    func stopActivity() {
        Task {
            await currentActivity?.end(nil, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }
}
