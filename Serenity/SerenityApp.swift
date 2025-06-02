import SwiftUI
import AVFoundation

@main
struct SerenityApp: App {
    @State private var showSplash = true
    
    init() {
        // Configure audio session for background playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        // Nasconde la splash screen dopo il caricamento
                        // Il timing è gestito dalla SplashScreenView stessa
                    }
            } else {
                ContentView()
                    .preferredColorScheme(.dark) // Force dark mode
            }
        }
    }
}
