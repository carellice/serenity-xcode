import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var titleOffset: CGFloat = 50
    @State private var titleOpacity: Double = 0.0
    @State private var progressValue: Double = 0.0
    @State private var showProgressBar = false
    @State private var loadingText = "Inizializzazione..."
    @State private var loadingComplete = false
    
    // Testi di caricamento
    private let loadingTexts = [
        "Inizializzazione...",
        "Caricamento suoni...",
        "Preparazione audio...",
        "Configurazione...",
        "Quasi pronto..."
    ]
    
    var body: some View {
        ZStack {
            if loadingComplete {
                ContentView()
                    .transition(.opacity)
            } else {
                // Background con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color("BackgroundColor"),
                        Color.black.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                // Particelle animate di sfondo
                ParticlesView()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo e icona principale
                    VStack(spacing: 20) {
                        ZStack {
                            // Cerchio di sfondo con glow
                            Circle()
                                .fill(
                                    RadialGradient(
                                        gradient: Gradient(colors: [
                                            Color.accentColor.opacity(0.3),
                                            Color.accentColor.opacity(0.1),
                                            Color.clear
                                        ]),
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 160, height: 160)
                                .scaleEffect(logoScale)
                                .opacity(logoOpacity)
                            
                            // Icona principale
                            Image(systemName: "moon.zzz.fill")
                                .font(.system(size: 60, weight: .light))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.accentColor,
                                            Color.accentColor.opacity(0.7)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .scaleEffect(logoScale)
                                .opacity(logoOpacity)
                                .symbolEffect(.pulse.byLayer, isActive: isLoading)
                        }
                        
                        // Titolo app
                        Text("Serenity")
                            .font(.system(size: 36, weight: .thin, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white,
                                        Color.white.opacity(0.8)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .offset(y: titleOffset)
                            .opacity(titleOpacity)
                        
                        // Sottotitolo
                        Text("Suoni per il relax e il sonno")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.secondary)
                            .offset(y: titleOffset)
                            .opacity(titleOpacity * 0.8)
                    }
                    
                    Spacer()
                    
                    // Sezione caricamento
                    VStack(spacing: 20) {
                        // Testo di caricamento
                        Text(loadingText)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .opacity(showProgressBar ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.3), value: loadingText)
                        
                        // Barra di progresso personalizzata
                        if showProgressBar {
                            VStack(spacing: 8) {
                                // Barra di progresso
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        // Background
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color.secondary.opacity(0.2))
                                            .frame(height: 8)
                                        
                                        // Progress
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        Color.accentColor,
                                                        Color.accentColor.opacity(0.7)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: geometry.size.width * (progressValue / 100), height: 8)
                                            .animation(.easeInOut(duration: 0.3), value: progressValue)
                                    }
                                }
                                .frame(height: 8)
                                
                                // Percentuale
                                Text("\(Int(progressValue))%")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 60)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                    }
                    .padding(.bottom, 60)
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Animazione logo
        withAnimation(.easeOut(duration: 1.0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Animazione titolo
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            titleOffset = 0
            titleOpacity = 1.0
        }
        
        // Mostra barra di progresso
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showProgressBar = true
            }
            startLoadingSequence()
        }
    }
    
    private func startLoadingSequence() {
        // Simula il caricamento con progressi realistici
        let loadingSteps = [
            (text: loadingTexts[0], progress: 20.0, delay: 0.0),
            (text: loadingTexts[1], progress: 40.0, delay: 0.8),
            (text: loadingTexts[2], progress: 60.0, delay: 1.2),
            (text: loadingTexts[3], progress: 85.0, delay: 1.0),
            (text: loadingTexts[4], progress: 100.0, delay: 0.8)
        ]
        
        var currentDelay = 0.0
        
        for step in loadingSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay) {
                loadingText = step.text
                
                withAnimation(.easeInOut(duration: 0.6)) {
                    progressValue = step.progress
                }
            }
            currentDelay += step.delay
        }
        
        // Completa il caricamento e mostra l'app
        DispatchQueue.main.asyncAfter(deadline: .now() + currentDelay + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                loadingComplete = true
            }
        }
    }
}

// Vista delle particelle animate
struct ParticlesView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 2...6))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(animate ? 0.0 : 1.0)
                    .animation(
                        .linear(duration: Double.random(in: 3...8))
                        .repeatForever(autoreverses: false)
                        .delay(Double.random(in: 0...2)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
