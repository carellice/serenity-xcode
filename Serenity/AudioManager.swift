import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    @Published var activeSounds: [UUID: Bool] = [:]
    @Published var soundVolumes: [UUID: Float] = [:]
    @Published var timerActive = false
    @Published var timerEndTime: Date?
    
    private var audioPlayers: [UUID: AVAudioPlayer] = [:]
    private var timerCancellable: AnyCancellable?
    
    // Sound categories
    var antiSounds: [Sound] {
        Sound.allSounds.filter { $0.category == .antiSounds }
    }
    
    var natureSounds: [Sound] {
        Sound.allSounds.filter { $0.category == .nature }
    }
    
    var travelSounds: [Sound] {
        Sound.allSounds.filter { $0.category == .travel }
    }
    
    var otherSounds: [Sound] {
        Sound.allSounds.filter { $0.category == .other }
    }
    
    init() {
        setupAudioSession()
        preloadSounds()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func preloadSounds() {
        for sound in Sound.allSounds {
            loadSound(sound)
        }
    }
    
    private func loadSound(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: "mp3") else {
            // Try with .wav extension
            guard let wavUrl = Bundle.main.url(forResource: sound.fileName, withExtension: "wav") else {
                print("Sound file not found: \(sound.fileName)")
                return
            }
            createPlayer(for: sound, with: wavUrl)
            return
        }
        createPlayer(for: sound, with: url)
    }
    
    private func createPlayer(for sound: Sound, with url: URL) {
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1 // Loop indefinitely
            player.volume = 0
            player.prepareToPlay()
            audioPlayers[sound.id] = player
            soundVolumes[sound.id] = 0
            activeSounds[sound.id] = false
        } catch {
            print("Failed to create audio player for \(sound.fileName): \(error)")
        }
    }
    
    func setVolume(for sound: Sound, volume: Float) {
        soundVolumes[sound.id] = volume
        
        if let player = audioPlayers[sound.id] {
            player.volume = volume
            
            if volume > 0 && !player.isPlaying {
                player.play()
                activeSounds[sound.id] = true
            } else if volume == 0 && player.isPlaying {
                player.pause()
                player.currentTime = 0
                activeSounds[sound.id] = false
            }
        }
    }
    
    func stopAllSounds() {
        for (id, player) in audioPlayers {
            player.pause()
            player.currentTime = 0
            player.volume = 0
            soundVolumes[id] = 0
            activeSounds[id] = false
        }
    }
    
    func setTimer(minutes: Int) {
        if minutes == 0 {
            cancelTimer()
            return
        }
        
        timerEndTime = Date().addingTimeInterval(TimeInterval(minutes * 60))
        timerActive = true
        
        // Cancel any existing timer
        timerCancellable?.cancel()
        
        // Create new timer
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self,
                      let endTime = self.timerEndTime else { return }
                
                if Date() >= endTime {
                    self.timerExpired()
                }
            }
    }
    
    func cancelTimer() {
        timerEndTime = nil
        timerActive = false
        timerCancellable?.cancel()
    }
    
    private func timerExpired() {
        stopAllSounds()
        cancelTimer()
        
        // You could add a notification here
        // For now, we'll just stop the sounds
    }
    
    func getVolume(for sound: Sound) -> Float {
        return soundVolumes[sound.id] ?? 0
    }
}
