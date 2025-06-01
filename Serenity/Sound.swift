import Foundation

// Sound Model
struct Sound: Identifiable {
    let id = UUID()
    let name: String
    let fileName: String
    let icon: String
    let category: SoundCategory
}

enum SoundCategory {
    case antiSounds
    case nature
    case travel
    case other
}

// Extension to create all sounds
extension Sound {
    static let allSounds: [Sound] = [
        // Anti Sounds
        Sound(name: "Rumore Bianco", fileName: "white-noise", icon: "waveform", category: .antiSounds),
        Sound(name: "Rumore Marrone", fileName: "brown-noise", icon: "waveform", category: .antiSounds),
        Sound(name: "Rumore Rosa", fileName: "pink-noise", icon: "waveform", category: .antiSounds),
        
        // Nature
        Sound(name: "Pioggia", fileName: "rain", icon: "cloud.rain.fill", category: .nature),
        Sound(name: "Tempesta", fileName: "storm", icon: "cloud.bolt.rain.fill", category: .nature),
        Sound(name: "Vento", fileName: "wind", icon: "wind", category: .nature),
        Sound(name: "Torrente", fileName: "stream", icon: "drop.fill", category: .nature),
        Sound(name: "Uccelli", fileName: "birds", icon: "bird.fill", category: .nature),
        Sound(name: "Onde", fileName: "waves", icon: "water.waves", category: .nature),
        
        // Travel
        Sound(name: "Barca", fileName: "boat", icon: "sailboat.fill", category: .travel),
        Sound(name: "Città", fileName: "city", icon: "building.2.fill", category: .travel),
        
        // Other
        Sound(name: "Falò", fileName: "fireplace", icon: "flame.fill", category: .other),
        Sound(name: "Asciugacapelli", fileName: "hair-dryer", icon: "wind", category: .other)
    ]
}
