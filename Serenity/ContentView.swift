import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var showingTimerSheet = false
    @State private var isLocked = false
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        if showOnboarding {
            OnboardingView()
        } else {
            mainAppView
        }
    }
    
    private var mainAppView: some View {
        NavigationView {
            ZStack {
                // Background gradiente
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color("BackgroundColor"),
                        Color.black.opacity(0.9)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Control Buttons Section
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            ControlButton(
                                icon: "stop.fill",
                                title: "Stop",
                                isActive: audioManager.activeSounds.values.contains(true),
                                action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        audioManager.stopAllSounds()
                                    }
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
                                title: isLocked ? "Bloccato" : "Blocca",
                                isActive: isLocked,
                                action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        isLocked.toggle()
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    
                    // Main Content
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 32) {
                            // Anti Sounds Section
                            SoundSectionView(
                                title: "Anti Suoni",
                                sounds: audioManager.antiSounds,
                                audioManager: audioManager,
                                isLocked: isLocked,
                                categoryColor: .purple
                            )
                            
                            // Nature Section
                            SoundSectionView(
                                title: "Natura",
                                sounds: audioManager.natureSounds,
                                audioManager: audioManager,
                                isLocked: isLocked,
                                categoryColor: .green
                            )
                            
                            // Travel Section
                            SoundSectionView(
                                title: "Viaggio",
                                sounds: audioManager.travelSounds,
                                audioManager: audioManager,
                                isLocked: isLocked,
                                categoryColor: .blue
                            )
                            
                            // Other Section
                            SoundSectionView(
                                title: "Altro",
                                sounds: audioManager.otherSounds,
                                audioManager: audioManager,
                                isLocked: isLocked,
                                categoryColor: .orange
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Control Button Component
struct ControlButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    private var buttonColor: Color {
        switch icon {
        case "stop.fill":
            return .red
        case "clock.fill":
            return .orange
        case "lock.fill", "lock.open.fill":
            return .purple
        default:
            return .accentColor
        }
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Glow effect per stop button attivo
                if icon == "stop.fill" && isActive {
                    Circle()
                        .fill(buttonColor.opacity(0.4))
                        .frame(width: 44, height: 44)
                        .blur(radius: 8)
                        .scaleEffect(isPressed ? 1.2 : 1.1)
                }
                
                Circle()
                    .fill(isActive ? buttonColor : Color.white.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(isActive ? buttonColor.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(isActive ? .white : .secondary)
                    .symbolEffect(.pulse, isActive: isActive && icon == "stop.fill")
            }
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .animation(.easeInOut(duration: 0.2), value: isActive)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled((icon == "stop.fill") && !isActive)
        .onLongPressGesture(minimumDuration: 0) {
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
    }
}

// MARK: - Sound Section View
struct SoundSectionView: View {
    let title: String
    let sounds: [Sound]
    @ObservedObject var audioManager: AudioManager
    let isLocked: Bool
    let categoryColor: Color
    
    private var activeSoundsCount: Int {
        sounds.filter { audioManager.activeSounds[$0.id] == true }.count
    }
    
    private let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 160), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Section Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(categoryColor)
                            .frame(width: 4, height: 28)
                        
                        Text(title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    if activeSoundsCount > 0 {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(categoryColor)
                                .frame(width: 6, height: 6)
                            
                            Text("\(activeSoundsCount) attiv\(activeSoundsCount == 1 ? "o" : "i")")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(categoryColor)
                        }
                        .padding(.leading, 16)
                    }
                }
                
                Spacer()
                
                if activeSoundsCount > 0 {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            for sound in sounds {
                                if audioManager.activeSounds[sound.id] == true {
                                    audioManager.setVolume(for: sound, volume: 0)
                                }
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "stop.circle.fill")
                                .font(.system(size: 14))
                            Text("Stop")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.red.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(Color.red.opacity(0.4), lineWidth: 1)
                                )
                        )
                        .foregroundColor(.red)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            // Sound Grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(sounds) { sound in
                    SoundCardView(
                        sound: sound,
                        audioManager: audioManager,
                        isLocked: isLocked,
                        categoryColor: categoryColor
                    )
                }
            }
        }
    }
}

// MARK: - Sound Card View
struct SoundCardView: View {
    let sound: Sound
    @ObservedObject var audioManager: AudioManager
    let isLocked: Bool
    let categoryColor: Color
    
    @State private var showingVolumeControl = false
    @State private var isPressed = false
    @State private var glowAnimation = false
    
    private var isActive: Bool {
        audioManager.activeSounds[sound.id] ?? false
    }
    
    private var currentVolume: Float {
        audioManager.getVolume(for: sound)
    }
    
    var body: some View {
        Button(action: {
            if !isLocked {
                showingVolumeControl = true
            }
        }) {
            ZStack {
                // Background glow for active sounds
                if isActive {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(categoryColor.opacity(0.3))
                        .blur(radius: 15)
                        .scaleEffect(glowAnimation ? 1.1 : 1.0)
                        .opacity(glowAnimation ? 0.8 : 0.4)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: glowAnimation)
                }
                
                // Main card
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: isActive ? [
                                categoryColor.opacity(0.4),
                                categoryColor.opacity(0.2),
                                Color.white.opacity(0.1)
                            ] : [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05),
                                Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(isActive ? 0.3 : 0.1),
                                        Color.clear,
                                        Color.white.opacity(isActive ? 0.1 : 0.05)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                
                // Content
                VStack(spacing: 16) {
                    // Icon section
                    ZStack {
                        // Icon background
                        Circle()
                            .fill(isActive ? categoryColor.opacity(0.2) : Color.white.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(isActive ? 1.1 : 1.0)
                        
                        // Ripple effect for active sounds
                        if isActive {
                            ForEach(0..<2, id: \.self) { index in
                                Circle()
                                    .stroke(categoryColor.opacity(0.4), lineWidth: 2)
                                    .frame(width: 60 + CGFloat(index) * 20)
                                    .scaleEffect(glowAnimation ? 1.3 : 1.0)
                                    .opacity(glowAnimation ? 0.0 : 0.8)
                                    .animation(
                                        .easeOut(duration: 1.5)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(index) * 0.5),
                                        value: glowAnimation
                                    )
                            }
                        }
                        
                        Image(systemName: sound.icon)
                            .font(.system(size: 28, weight: .light))
                            .foregroundColor(isActive ? categoryColor : .secondary)
                            .symbolEffect(.pulse.byLayer, isActive: isActive)
                    }
                    
                    // Text section
                    VStack(spacing: 8) {
                        Text(sound.name)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                        if isActive {
                            // Volume indicator
                            VStack(spacing: 4) {
                                // Volume bar
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(Color.white.opacity(0.2))
                                            .frame(height: 3)
                                        
                                        RoundedRectangle(cornerRadius: 2)
                                            .fill(categoryColor)
                                            .frame(
                                                width: geometry.size.width * CGFloat(currentVolume),
                                                height: 3
                                            )
                                            .animation(.easeInOut(duration: 0.2), value: currentVolume)
                                    }
                                }
                                .frame(height: 3)
                                
                                Text("\(Int(currentVolume * 100))%")
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(categoryColor)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(categoryColor.opacity(0.2))
                                    )
                            }
                        } else {
                            Text("Tocca per riprodurre")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
            }
            .frame(height: 160)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLocked)
        .contextMenu {
            SoundContextMenu(
                sound: sound,
                audioManager: audioManager,
                isActive: isActive,
                categoryColor: categoryColor
            )
        }
        .onLongPressGesture(minimumDuration: 0) {
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
        .sheet(isPresented: $showingVolumeControl) {
            VolumeControlView(sound: sound, audioManager: audioManager)
        }
        .onAppear {
            if isActive {
                glowAnimation = true
            }
        }
        .onChange(of: isActive) { newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                glowAnimation = newValue
            }
        }
    }
}

// MARK: - Sound Context Menu
struct SoundContextMenu: View {
    let sound: Sound
    @ObservedObject var audioManager: AudioManager
    let isActive: Bool
    let categoryColor: Color
    
    var body: some View {
        VStack {
            // Header
            Label(sound.name, systemImage: sound.icon)
                .foregroundColor(categoryColor)
                .fontWeight(.semibold)
            
            Divider()
            
            if isActive {
                // Stop option
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 0)
                    }
                }) {
                    Label("Ferma", systemImage: "stop.fill")
                        .foregroundColor(.red)
                }
                
                // Volume options
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 0.25)
                    }
                }) {
                    Label("Volume 25%", systemImage: "speaker.wave.1.fill")
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 0.5)
                    }
                }) {
                    Label("Volume 50%", systemImage: "speaker.wave.2.fill")
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 1.0)
                    }
                }) {
                    Label("Volume 100%", systemImage: "speaker.wave.3.fill")
                }
            } else {
                // Start options
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 0.25)
                    }
                }) {
                    Label("Avvia - Volume Basso", systemImage: "play.fill")
                        .foregroundColor(categoryColor)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 0.5)
                    }
                }) {
                    Label("Avvia - Volume Medio", systemImage: "play.fill")
                        .foregroundColor(categoryColor)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        audioManager.setVolume(for: sound, volume: 1.0)
                    }
                }) {
                    Label("Avvia - Volume Alto", systemImage: "play.fill")
                        .foregroundColor(categoryColor)
                }
            }
        }
    }
}

// MARK: - Lock Overlay
struct LockOverlay: View {
    @Binding var isLocked: Bool
    @State private var position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.95)
                .ignoresSafeArea()
                .onTapGesture {
                    // Prevent accidental taps
                }
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .blur(radius: 20)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 8) {
                    Text("Schermo Bloccato")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Tocca per sbloccare e continuare")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isLocked = false
                    }
                }) {
                    Text("Sblocca")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.white)
                        )
                }
            }
            .position(position)
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 0.8)) {
                    position = randomPosition()
                }
            }
        }
    }
    
    private func randomPosition() -> CGPoint {
        let padding: CGFloat = 120
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
