<p align="center">
  <a href="https://www.flavioceccarelli.org" target="_blank">
    <img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83" alt="Download on the App Store" style="height: 60px;">
  </a>
</p>

# 🌙 Serenity

**L'app definitiva per il relax e il sonno profondo**

Serenity è un'applicazione iOS nativa sviluppata in SwiftUI che ti aiuta a rilassarti e dormire meglio attraverso una collezione curata di suoni ambientali di alta qualità. Crea il tuo mix perfetto di suoni per meditazione, concentrazione o sonno.

---

## 📸 Screenshot

<p align="center">
  <img src="screenshots/home.png" alt="Home Screen" width="230">
  <img src="screenshots/volume.png" alt="Volume Control" width="230">
  <img src="screenshots/timer.png" alt="Timer" width="230">
  <img src="screenshots/splash.png" alt="Splash Screen" width="230">
</p>

---

## ✨ Caratteristiche Principali

### 🎵 Libreria Suoni Completa
- **Anti Suoni**: Rumore bianco, rosa e marrone per mascherare i disturbi
- **Natura**: Pioggia, tempesta, vento, torrenti, uccelli e onde del mare
- **Viaggio**: Suoni di barca e città per ambientazioni specifiche
- **Altri**: Falò, asciugacapelli e altri suoni rilassanti

### 🎛️ Controllo Avanzato del Volume
- **Slider moderni** con gradienti colorati dinamici
- **Controllo individuale** del volume per ogni suono
- **Pulsanti rapidi** per volumi preimpostati (25%, 50%, 75%, 100%)
- **Visualizzazione in tempo reale** delle percentuali di volume

### ⏰ Timer Intelligente
- **Timer preimpostati**: 5, 15, 30, 60, 120 minuti
- **Timer personalizzato** con qualsiasi durata
- **Spegnimento automatico** quando il timer termina
- **Visualizzazione countdown** in tempo reale

### 🔒 Modalità Blocco Schermo
- **Protezione accidentale** per evitare modifiche involontarie
- **Pulsante di sblocco mobile** che cambia posizione ogni 3 secondi
- **Overlay scuro** che copre l'interfaccia

### 🎨 Design Moderno e Accattivante
- **Interfaccia dark mode** ottimizzata per l'uso notturno
- **Animazioni fluide** e feedback visivo
- **Card animate** con effetti glow per suoni attivi
- **Pulsanti intelligenti** che si illuminano quando necessario

### 📱 Live Activities (iOS 16+)
- **Dynamic Island** con controlli rapidi
- **Lock Screen widgets** per controllo senza sbloccare
- **Visualizzazione suoni attivi** e timer rimanente

---

## 🛠 Tecnologie Utilizzate

- **Framework**: SwiftUI nativo
- **Audio**: AVFoundation per riproduzione audio di alta qualità
- **Live Activities**: ActivityKit per Dynamic Island e Lock Screen
- **Background Audio**: Riproduzione continua in background
- **Animazioni**: SwiftUI native con effetti moderni
- **Architettura**: MVVM con ObservableObject

## 📋 Requisiti di Sistema

- **iOS**: 18.4 o superiore
- **Xcode**: 16.3 o superiore
- **Swift**: 5.0 o superiore
- **Dispositivi**: iPhone e iPad (Universal)

## 🚀 Installazione e Setup

### Clone del Repository
```bash
git clone https://github.com/carellice/serenity-xcode.git
cd serenity-xcode
```

### Configurazione Xcode
1. Apri `Serenity.xcodeproj` in Xcode
2. Seleziona il tuo team di sviluppo in Signing & Capabilities
3. Modifica il Bundle Identifier se necessario
4. Assicurati che le Live Activities siano abilitate
5. Compila ed esegui su simulatore o dispositivo

### File Audio Inclusi
L'app include una collezione completa di file audio di alta qualità:
- Formati supportati: MP3 e WAV
- Audio ottimizzati per loop continui
- Dimensioni bilanciate per qualità/performance

---

## 📁 Struttura del Progetto

```
Serenity/
├── 📱 App/
│   ├── SerenityApp.swift           # Entry point dell'app
│   ├── ContentView.swift           # Vista principale con controlli
│   ├── SplashScreenView.swift      # Schermata di caricamento animata
│   └── Info.plist                 # Configurazione app e background modes
├── 🗄️ Models/
│   └── Sound.swift                 # Modello dati per i suoni
├── 👁️ Views/
│   ├── VolumeControlView.swift     # Controllo volume moderno
│   ├── TimerView.swift             # Gestione timer
│   └── Components/                 # Componenti riutilizzabili
├── 🎛️ Managers/
│   ├── AudioManager.swift          # Gestione riproduzione audio
│   └── LiveActivityManager.swift   # Gestione Live Activities
├── 🎨 Extensions/
│   └── Color+Extensions.swift      # Colori personalizzati
├── 🎵 Sounds/                      # File audio
│   ├── rain.wav
│   ├── storm.mp3
│   ├── white-noise.mp3
│   └── [altri file audio...]
├── 📱 SerenityWidget/              # Widget e Live Activities
│   ├── SerenityWidget.swift        # Implementazione widget
│   └── Info.plist                 # Configurazione widget
└── 📦 Shared/
    └── SerenityShared.swift        # Codice condiviso app/widget
```

## 🎯 Funzionalità Principali

### Audio Engine
- **Riproduzione simultanea** di più suoni
- **Loop infiniti** senza interruzioni
- **Controllo volume individuale** per ogni traccia
- **Audio in background** senza interruzioni

### Interfaccia Utente
- **Sezioni categorizzate** per tipo di suono
- **Indicatori visivi** per suoni attivi
- **Animazioni fluide** e feedback tattile
- **Design responsive** per tutti i dispositivi iOS

### Live Activities
- **Dynamic Island** con controlli rapidi
- **Lock Screen** integration per controllo senza sblocco
- **Stato in tempo reale** dei suoni riprodotti

## 🎨 Design System

### Colori
- **Accent Color**: Personalizzabile dal sistema
- **Categorici**: Viola (Anti Suoni), Verde (Natura), Blu (Viaggio), Arancione (Altri)
- **Gradienti**: Dinamici per slider e effetti

### Animazioni
- **Scale Effects**: Per feedback di pressione
- **Opacity Transitions**: Per stati attivo/inattivo
- **Glow Effects**: Per elementi illuminati
- **Symbol Effects**: Pulse, bounce per icone

## 🎯 Roadmap

### Versione 1.1
- [ ] Preset personalizzabili di mix di suoni
- [ ] Integrazione con Shortcuts di iOS
- [ ] Statistiche di utilizzo e sonno
- [ ] Nuovi suoni e categorie

### Versione 1.2
- [ ] Supporto AirPods e controlli esterni
- [ ] Modalità focus personalizzabili
- [ ] Sync iCloud per preferenze
- [ ] Widget per Home Screen

## 🤝 Contribuire

I contributi sono benvenuti! Per contribuire:

1. **Fork** il repository
2. **Crea** un branch per la tua feature (`git checkout -b feature/NewSound`)
3. **Commit** le tue modifiche (`git commit -m 'Add new nature sound'`)
4. **Push** al branch (`git push origin feature/NewSound`)
5. **Apri** una Pull Request

### Linee Guida per i Contributi
- Segui le convenzioni SwiftUI esistenti
- Mantieni la coerenza del design system
- Testa su dispositivi reali per audio e performance
- Documenta le nuove funzionalità

## 🐛 Bug Report e Feature Request

Per segnalare bug o richiedere nuove funzionalità, apri una [issue](https://github.com/carellice/serenity-xcode/issues) con:

**Per i Bug:**
- Descrizione dettagliata del problema
- Passi per riprodurre il bug
- Screenshots/video se applicabili
- Versione iOS e modello dispositivo
- Comportamento audio specifico

**Per le Feature:**
- Descrizione chiara della funzionalità
- Casi d'uso per relax/sonno
- Esempi di suoni o funzionalità simili
- Mockup dell'interfaccia se disponibili

## 🎵 Note sui Diritti Audio

I file audio inclusi in questo progetto sono:
- Royalty-free o di dominio pubblico
- Ottimizzati per uso in loop continui
- Registrati/processati per qualità ottimale

Per aggiungere nuovi suoni, assicurati che siano:
- Liberi da copyright o con licenza appropriata
- In formato MP3 o WAV di alta qualità
- Ottimizzati per loop senza interruzioni percettibili

## 📄 Licenza

Questo progetto è rilasciato sotto licenza MIT. Vedi il file [LICENSE](LICENSE) per i dettagli.

---

## 👨‍💻 Autore

**Flavio Ceccarelli** - [@carellice](https://github.com/carellice)

- 🌐 Website: [flavioceccarelli.org](https://www.flavioceccarelli.org)
- 📧 Email: [Contatta tramite GitHub](https://github.com/carellice)

---

**🌙 Ti piace Serenity?** Lascia una stella al repository e condividilo con chi cerca il relax perfetto!

**💤 Dormi meglio, vivi meglio** - Serenity è qui per accompagnarti verso un sonno profondo e rigenerante.
