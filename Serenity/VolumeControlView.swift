import SwiftUI

struct VolumeControlView: View {
    let sound: Sound
    @ObservedObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    @State private var isDragging = false
    
    // Computed property che legge direttamente dall'AudioManager
    private var volume: Float {
        get { audioManager.getVolume(for: sound) }
        nonmutating set { audioManager.setVolume(for: sound, volume: newValue) }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header con icona e nome del suono
                    VStack(spacing: 20) {
                        // Icona animata
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.accentColor.opacity(0.3),
                                            Color.accentColor.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(volume > 0 ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: volume)
                            
                            Image(systemName: sound.icon)
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(.accentColor)
                                .symbolEffect(.pulse, isActive: volume > 0)
                        }
                        
                        Text(sound.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    // Volume Slider Personalizzato
                    VStack(spacing: 30) {
                        // Valore percentuale
                        Text("\(Int(volume * 100))%")
                            .font(.system(size: 48, weight: .thin, design: .rounded))
                            .foregroundColor(.primary)
                            .animation(.easeInOut(duration: 0.2), value: volume)
                        
                        // Slider personalizzato
                        CustomVolumeSlider(
                            value: Binding(
                                get: { volume },
                                set: { newValue in
                                    audioManager.setVolume(for: sound, volume: newValue)
                                }
                            ),
                            isDragging: $isDragging,
                            onChange: { newValue in
                                audioManager.setVolume(for: sound, volume: newValue)
                            }
                        )
                        .frame(height: 60)
                        .padding(.horizontal, 40)
                        
                        // Indicatori di volume
                        HStack(spacing: 30) {
                            VStack(spacing: 8) {
                                Image(systemName: "speaker.fill")
                                    .font(.title2)
                                    .foregroundColor(volume == 0 ? .accentColor : .secondary)
                                Text("Muto")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .opacity(volume == 0 ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 0.2), value: volume)
                            
                            Spacer()
                            
                            VStack(spacing: 8) {
                                Image(systemName: "speaker.wave.3.fill")
                                    .font(.title2)
                                    .foregroundColor(volume == 1.0 ? .accentColor : .secondary)
                                Text("Max")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .opacity(volume == 1.0 ? 1.0 : 0.5)
                            .animation(.easeInOut(duration: 0.2), value: volume)
                        }
                        .padding(.horizontal, 50)
                    }
                    
                    Spacer()
                    
                    // Controlli rapidi
                    HStack(spacing: 20) {
                        QuickVolumeButton(value: 0.25, currentValue: volume, label: "25%") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                audioManager.setVolume(for: sound, volume: 0.25)
                            }
                        }
                        
                        QuickVolumeButton(value: 0.5, currentValue: volume, label: "50%") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                audioManager.setVolume(for: sound, volume: 0.5)
                            }
                        }
                        
                        QuickVolumeButton(value: 0.75, currentValue: volume, label: "75%") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                audioManager.setVolume(for: sound, volume: 0.75)
                            }
                        }
                        
                        QuickVolumeButton(value: 1.0, currentValue: volume, label: "100%") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                audioManager.setVolume(for: sound, volume: 1.0)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(Color("BackgroundColor").ignoresSafeArea())
            .navigationTitle("Volume")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundColor(.accentColor)
                    .fontWeight(.medium)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Forza stile iPhone anche su iPad
    }
}

// Slider personalizzato
struct CustomVolumeSlider: View {
    @Binding var value: Float
    @Binding var isDragging: Bool
    let onChange: (Float) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track di sfondo
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.secondary.opacity(0.2))
                    .frame(height: 8)
                
                // Track attivo con gradiente
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color.green, location: 0.0),
                                .init(color: Color.yellow, location: 0.5),
                                .init(color: Color.orange, location: 0.8),
                                .init(color: Color.red, location: 1.0)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(value) * geometry.size.width, height: 8)
                    .animation(.easeInOut(duration: 0.1), value: value)
                
                // Thumb (maniglia)
                Circle()
                    .fill(Color.white)
                    .frame(width: isDragging ? 35 : 25, height: isDragging ? 35 : 25)
                    .shadow(color: .black.opacity(0.2), radius: isDragging ? 8 : 4, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .stroke(Color.accentColor, lineWidth: isDragging ? 3 : 2)
                    )
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
                    .position(
                        x: max(12.5, min(geometry.size.width - 12.5, CGFloat(value) * geometry.size.width)),
                        y: geometry.size.height / 2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        isDragging = true
                        let newValue = Float(max(0, min(1, gesture.location.x / geometry.size.width)))
                        value = newValue
                        onChange(newValue)
                    }
                    .onEnded { _ in
                        isDragging = false
                    }
            )
        }
    }
}

// Pulsanti di volume rapido
struct QuickVolumeButton: View {
    let value: Float
    let currentValue: Float
    let label: String
    let action: () -> Void
    
    private var isSelected: Bool {
        abs(currentValue - value) < 0.05
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(width: 60, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor : Color("CardBackground"))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
