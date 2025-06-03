import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            // Background
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
            
            VStack {
                // Progress indicator
                HStack {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        Circle()
                            .fill(index <= currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.top, 20)
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                // Bottom buttons
                VStack(spacing: 20) {
                    if currentPage < onboardingPages.count - 1 {
                        // Continue button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        }) {
                            HStack {
                                Text("Continua")
                                    .font(.system(size: 18, weight: .medium))
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            )
                        }
                        
                        // Skip button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showMainApp = true
                            }
                        }) {
                            Text("Salta introduzione")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    } else {
                        // Start button (last page)
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                showMainApp = true
                            }
                        }) {
                            HStack {
                                Text("Inizia il relax")
                                    .font(.system(size: 18, weight: .medium))
                                Image(systemName: "moon.zzz.fill")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.accentColor,
                                                Color.accentColor.opacity(0.8)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            ContentView()
        }
        .onAppear {
            // Salva che l'onboarding è stato visto
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        }
    }
}

// Single page view
struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var animateIcon = false
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated icon
            ZStack {
                // Background circle with glow
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                page.color.opacity(0.3),
                                page.color.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 30,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateIcon ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
                
                // Main icon
                Image(systemName: page.icon)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(page.color)
                    .scaleEffect(animateContent ? 1.0 : 0.8)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .symbolEffect(.pulse.byLayer, isActive: animateIcon)
            }
            
            // Content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.system(size: 28, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                
                Text(page.description)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 30)
                
                // Feature highlights
                VStack(spacing: 8) {
                    ForEach(page.features, id: \.self) { feature in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(page.color)
                                .font(.system(size: 14))
                            
                            Text(feature)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()
                        }
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(x: animateContent ? 0 : -30)
                        .animation(.easeOut(duration: 0.6).delay(Double(page.features.firstIndex(of: feature) ?? 0) * 0.1), value: animateContent)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateContent = true
            }
            animateIcon = true
        }
    }
}

// Data model for onboarding pages
struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let features: [String]
    let color: Color
}

// Onboarding content
let onboardingPages = [
    OnboardingPage(
        icon: "moon.zzz.fill",
        title: "Benvenuto in Serenity",
        description: "La tua oasi personale di relax e sonno profondo. Scopri come funziona la magia dei suoni.",
        features: [
            "Suoni di alta qualità",
            "Design per il benessere",
            "Sempre in modalità scura"
        ],
        color: .accentColor
    ),
    
    OnboardingPage(
        icon: "speaker.wave.3.fill",
        title: "Crea il Tuo Mix Perfetto",
        description: "Combina più suoni contemporaneamente per creare l'atmosfera ideale per te.",
        features: [
            "Riproduci più suoni insieme",
            "Controlla ogni volume",
            "Preferenze automatiche"
        ],
        color: .green
    ),
    
    OnboardingPage(
        icon: "slider.horizontal.3",
        title: "Controlli Avanzati",
        description: "Slider moderni e intuitivi per controllare ogni dettaglio della tua esperienza sonora.",
        features: [
            "Slider con gradienti colorati",
            "Pulsanti rapidi preimpostati",
            "Percentuali in tempo reale"
        ],
        color: .orange
    ),
    
    OnboardingPage(
        icon: "clock.fill",
        title: "Timer Intelligente",
        description: "Imposta un timer per spegnere automaticamente i suoni quando non servono più.",
        features: [
            "Timer preimpostati rapidi",
            "Timer personalizzabile",
            "Spegnimento dolce"
        ],
        color: .blue
    ),
    
    OnboardingPage(
        icon: "lock.fill",
        title: "Modalità Blocco",
        description: "Attiva il blocco schermo per evitare tocchi accidentali durante la notte.",
        features: [
            "Previene interruzioni",
            "Pulsante mobile",
            "Perfetto per la notte"
        ],
        color: .purple
    ),
    
    OnboardingPage(
        icon: "heart.fill",
        title: "Tutto Pronto!",
        description: "Ora sei pronto per iniziare il tuo viaggio verso un relax profondo e un sonno rigenerante.",
        features: [
            "Esplora le categorie",
            "Sperimenta i mix",
            "Goditi la serenità"
        ],
        color: .pink
    )
]

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
