import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var showingTimerSheet = false
    @State private var isLocked = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Control Buttons
                    HStack(spacing: 30) {
                        ControlButton(
                            icon: "stop.fill",
                            title: "Stop",
                            isActive: false,
                            action: {
                                audioManager.stopAllSounds()
                            }
                        )
                        
                        ControlButton(
                            icon: "clock.fill",
                            title: "Timer",
                            isActive: audioManager.timerActive,
                            action: {
                                showingTimerSheet = true
                            }
                        )
                        
                        ControlButton(
                            icon: isLocked ? "lock.fill" : "lock.open.fill",
                            title: "Blocca",
                            isActive: isLocked,
                            action: {
                                isLocked.toggle()
                            }
                        )
                    }
                    .padding(.top)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 25) {
                            // Anti Sounds Section
                            SoundSection(
                                title: "Anti Suoni",
                                sounds: audioManager.antiSounds,
                                audioManager: audioManager,
                                isLocked: isLocked
                            )
                            
                            // Nature Section
                            SoundSection(
                                title: "Natura",
                                sounds: audioManager.natureSounds,
                                audioManager: audioManager,
                                isLocked: isLocked
                            )
                            
                            // Travel Section
                            SoundSection(
                                title: "Viaggio",
                                sounds: audioManager.travelSounds,
                                audioManager: audioManager,
                                isLocked: isLocked
                            )
                            
                            // Other Section
                            SoundSection(
                                title: "Altro",
                                sounds: audioManager.otherSounds,
                                audioManager: audioManager,
                                isLocked: isLocked
                            )
                        }
                        .padding()
                    }
                }
                
                // Lock Overlay
                if isLocked {
                    LockOverlay(isLocked: $isLocked)
                }
            }
            .navigationTitle("Serenity")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingTimerSheet) {
                TimerView(audioManager: audioManager)
            }
        }
    }
}

// Control Button Component
struct ControlButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(isActive ? .accentColor : .primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(width: 90, height: 90)
            .background(Color("CardBackground"))
            .cornerRadius(12)
        }
    }
}

// Sound Section Component
struct SoundSection: View {
    let title: String
    let sounds: [Sound]
    let audioManager: AudioManager
    let isLocked: Bool
    
    let columns = [
        GridItem(.adaptive(minimum: 110))
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(sounds) { sound in
                    SoundCard(
                        sound: sound,
                        audioManager: audioManager,
                        isLocked: isLocked
                    )
                }
            }
        }
    }
}

// Sound Card Component
struct SoundCard: View {
    let sound: Sound
    @ObservedObject var audioManager: AudioManager
    let isLocked: Bool
    @State private var showingVolumeControl = false
    
    var isActive: Bool {
        audioManager.activeSounds[sound.id] ?? false
    }
    
    var body: some View {
        Button(action: {
            if !isLocked {
                showingVolumeControl = true
            }
        }) {
            VStack(spacing: 12) {
                Image(systemName: sound.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isActive ? .accentColor : .secondary)
                
                Text(sound.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                // Active Indicator
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 8, height: 8)
                    .opacity(isActive ? 1 : 0)
            }
            .frame(width: 110, height: 110)
            .background(Color("CardBackground"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isActive ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .disabled(isLocked)
        .sheet(isPresented: $showingVolumeControl) {
            VolumeControlView(sound: sound, audioManager: audioManager)
        }
    }
}

// Lock Overlay
struct LockOverlay: View {
    @Binding var isLocked: Bool
    @State private var position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
                .onTapGesture {
                    // Previene tap accidentali
                }
            
            VStack(spacing: 20) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.white)
                
                Text("Schermo bloccato")
                    .font(.title3)
                    .foregroundColor(.white)
                
                Button("Sblocca") {
                    isLocked = false
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .position(position)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    position = randomPosition()
                }
            }
        }
    }
    
    func randomPosition() -> CGPoint {
        let padding: CGFloat = 100
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let x = CGFloat.random(in: padding...(screenWidth - padding))
        let y = CGFloat.random(in: padding...(screenHeight - padding))
        
        return CGPoint(x: x, y: y)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
