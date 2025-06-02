import SwiftUI

extension Color {
    // Colori personalizzati per l'app
    static let customBackground = Color("BackgroundColor")
    static let customCard = Color("CardBackground")
    
    // Colori per le categorie di suoni
    static let antiSoundsColor = Color.purple
    static let natureColor = Color.green
    static let travelColor = Color.blue
    static let otherColor = Color.orange
    
    // Funzione per ottenere il colore della categoria
    static func colorForCategory(_ category: SoundCategory) -> Color {
        switch category {
        case .antiSounds:
            return .purple
        case .nature:
            return .green
        case .travel:
            return .blue
        case .other:
            return .orange
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
