import SwiftUI

struct VolumeControlView: View {
    let sound: Sound
    @ObservedObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    @State private var volume: Float = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Sound Icon and Name
                VStack(spacing: 15) {
                    Image(systemName: sound.icon)
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    
                    Text(sound.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 40)
                
                // Volume Slider
                VStack(spacing: 20) {
                    Slider(value: $volume, in: 0...1) { _ in
                        audioManager.setVolume(for: sound, volume: volume)
                    }
                    .accentColor(.accentColor)
                    
                    Text("\(Int(volume * 100))%")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .navigationTitle("Volume")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            volume = audioManager.getVolume(for: sound)
        }
    }
}
