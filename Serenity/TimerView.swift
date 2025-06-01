import SwiftUI

struct TimerView: View {
    @ObservedObject var audioManager: AudioManager
    @Environment(\.dismiss) var dismiss
    @State private var customMinutes = ""
    @State private var remainingTime = ""
    
    let presetOptions = [5, 15, 30, 60, 120]
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Current Timer Status
                if audioManager.timerActive, let endTime = audioManager.timerEndTime {
                    VStack(spacing: 10) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 40))
                            .foregroundColor(.accentColor)
                            .symbolEffect(.pulse)
                        
                        Text(remainingTime)
                            .font(.title)
                            .fontWeight(.semibold)
                            .onReceive(timer) { _ in
                                updateRemainingTime(endTime: endTime)
                            }
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
                }
                
                // Preset Options
                VStack(spacing: 15) {
                    Text("Timer Preimpostati")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(presetOptions, id: \.self) { minutes in
                            Button(action: {
                                audioManager.setTimer(minutes: minutes)
                            }) {
                                Text(formatMinutes(minutes))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("CardBackground"))
                                    .foregroundColor(.primary)
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button(action: {
                            audioManager.cancelTimer()
                        }) {
                            Text("Disattiva")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.2))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Custom Timer
                VStack(spacing: 15) {
                    Text("Timer Personalizzato")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        TextField("Minuti", text: $customMinutes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        Button("Imposta") {
                            if let minutes = Int(customMinutes), minutes > 0 {
                                audioManager.setTimer(minutes: minutes)
                                customMinutes = ""
                                hideKeyboard()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Timer")
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
            if let endTime = audioManager.timerEndTime {
                updateRemainingTime(endTime: endTime)
            }
        }
    }
    
    private func formatMinutes(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) minuti"
        } else if minutes == 60 {
            return "1 ora"
        } else {
            return "\(minutes / 60) ore"
        }
    }
    
    private func updateRemainingTime(endTime: Date) {
        let remaining = endTime.timeIntervalSince(Date())
        if remaining > 0 {
            let hours = Int(remaining) / 3600
            let minutes = (Int(remaining) % 3600) / 60
            let seconds = Int(remaining) % 60
            remainingTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            remainingTime = "00:00:00"
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
