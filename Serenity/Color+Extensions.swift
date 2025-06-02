import SwiftUI

extension Color {
    // Colori personalizzati per l'app
    static let customBackground = Color("BackgroundColor")
    static let customCard = Color("CardBackground")
    
    // Gradienti per gli slider
    static let volumeGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color.green, location: 0.0),
            .init(color: Color.yellow, location: 0.3),
            .init(color: Color.orange, location: 0.7),
            .init(color: Color.red, location: 1.0)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Colori dinamici che si adattano al tema
    static let dynamicWhite = Color.primary.opacity(0.9)
    static let dynamicGray = Color.secondary.opacity(0.6)
    
    // Colori per le categorie di suoni
    static let antiSoundsColor = Color.purple
    static let natureColor = Color.green
    static let travelColor = Color.blue
    static let otherColor = Color.orange
    
    // Funzione per ottenere il colore della categoria
    static func colorForCategory(_ category: SoundCategory) -> Color {
        switch category {
        case .antiSounds:
            return .antiSoundsColor
        case .nature:
            return .natureColor
        case .travel:
            return .travelColor
        case .other:
            return .otherColor
        }
    }
}

// Estensione per creare gradienti personalizzati
extension LinearGradient {
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let activeCardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.accentColor.opacity(0.3),
            Color.accentColor.opacity(0.1)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
