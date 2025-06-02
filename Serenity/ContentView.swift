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
    
    // Colore della categoria basato sul primo suono
    private var categoryColor: Color {
        guard let firstSound = sounds.first else { return .accentColor }
        return Color.colorForCategory(firstSound.category)
    }
    
    // Conta i suoni attivi in questa sezione
    private var activeSoundsCount: Int {
        sounds.filter { sound in
            audioManager.activeSounds[sound.id] == true
        }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header della sezione migliorato
            HStack {
                HStack(spacing: 12) {
                    // Indicatore colorato della categoria
                    RoundedRectangle(cornerRadius: 3)
                        .fill(categoryColor)
                        .frame(width: 4, height: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if activeSoundsCount > 0 {
                            Text("\(activeSoundsCount) attiv\(activeSoundsCount == 1 ? "o" : "i")")
                                .font(.caption)
                                .foregroundColor(categoryColor)
                                .fontWeight(.medium)
                        }
                    }
                }
                
                Spacer()
                
                // Pulsante per fermare tutti i suoni della sezione
                if activeSoundsCount > 0 {
                    Button(action: {
                        // Ferma tutti i suoni di questa sezione
                        for sound in sounds {
                            if audioManager.activeSounds[sound.id] == true {
                                audioManager.setVolume(for: sound, volume: 0)
                            }
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "stop.fill")
                                .font(.caption)
                            Text("Stop")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.red.opacity(0.2))
                        )
                        .foregroundColor(.red)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.2), value: activeSoundsCount)
                }
            }
            .padding(.horizontal, 4)
            
            // Griglia dei suoni
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
        .padding(.vertical, 8)
    }
}

// Sound Card Component
// Sostituisci la struct SoundCard in ContentView.swift con questa versione moderna:

struct SoundCard: View {
    let sound: Sound
    @ObservedObject var audioManager: AudioManager
    let isLocked: Bool
    @State private var showingVolumeControl = false
    @State private var isPressed = false
    
    var isActive: Bool {
        audioManager.activeSounds[sound.id] ?? false
    }
    
    var currentVolume: Float {
        audioManager.getVolume(for: sound)
    }
    
    var body: some View {
        Button(action: {
            if !isLocked {
                showingVolumeControl = true
            }
        }) {
            ZStack {
                // Sfondo con gradiente
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: isActive ? [
                                Color.accentColor.opacity(0.3),
                                Color.accentColor.opacity(0.1)
                            ] : [
                                Color("CardBackground"),
                                Color("CardBackground").opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Bordo luminoso per suoni attivi
                if isActive {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.accentColor.opacity(0.8),
                                    Color.accentColor.opacity(0.4)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                }
                
                VStack(spacing: 12) {
                    // Icona con effetti
                    ZStack {
                        // Cerchio di sfondo per l'icona
                        Circle()
                            .fill(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
                            .frame(width: 50, height: 50)
                            .scaleEffect(isActive ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: isActive)
                        
                        Image(systemName: sound.icon)
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(isActive ? .accentColor : .secondary)
                            .symbolEffect(.pulse, isActive: isActive)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isPressed)
                    }
                    
                    // Nome del suono
                    Text(sound.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    // Indicatore di volume per suoni attivi
                    if isActive {
                        VStack(spacing: 4) {
                            // Barra di volume mini
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    RoundedRectangle(cornerRadius: 1)
                                        .fill(Color.accentColor)
                                        .frame(width: 3, height: CGFloat(4 + index * 2))
                                        .opacity(currentVolume > Float(index) * 0.2 ? 1.0 : 0.3)
                                        .animation(.easeInOut(duration: 0.2), value: currentVolume)
                                }
                            }
                            .frame(height: 12)
                            
                            // Percentuale volume
                            Text("\(Int(currentVolume * 100))%")
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        // Indicatore inattivo
                        Circle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
            }
            .frame(width: 110, height: 130)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            
            // Effetto glow per suoni attivi
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.accentColor)
                    .opacity(isActive ? 0.1 : 0)
                    .blur(radius: 8)
                    .scaleEffect(1.1)
                    .animation(.easeInOut(duration: 0.3), value: isActive)
            )
        }
        .disabled(isLocked)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.0) {
            // Questo non viene mai chiamato, ma permette di avere onChanged
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
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
