import SwiftUI
import Speech
import AVFoundation

class CategoriesScreenViewModel: ObservableObject {
    @Published var isArabic: Bool = false
    @Published var isRecording: Bool = false
    @Published var navigateToSpace: Bool = false
    @Published var navigateToNature: Bool = false
    @Published var navigateToAnimals: Bool = false
    
    private var audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    func toggleLanguage() {
        isArabic.toggle()
    }
    
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                DispatchQueue.main.async { // Ensure this update is on the main thread
                    self.isRecording = true
                }
                do {
                    try self.startAudioEngine()
                } catch {
                    print("Audio engine error: \(error)")
                }
            }
        }
    }
    
    private func startAudioEngine() throws {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        let localeIdentifier = (languageCode == "ar") ? "ar_SA" : "en_US"
        
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: localeIdentifier)) else { return }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            if let result = result {
                DispatchQueue.main.async { // Ensure this update is on the main thread
                    self.handleVoiceCommand(result.bestTranscription.formattedString)
                }
            }
            if error != nil {
                DispatchQueue.main.async { // Ensure this update is on the main thread
                    self.stopRecording()
                }
            }
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        DispatchQueue.main.async { // Ensure this update is on the main thread
            self.isRecording = true
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        
        DispatchQueue.main.async { // Ensure this update is on the main thread
            self.isRecording = false
        }
    }
    
    private func handleVoiceCommand(_ command: String) {
        DispatchQueue.main.async { // Ensure this update is on the main thread
            if command.contains("space") || command.contains("الفضاء") {
                self.navigateToSpace = true
            } else if command.contains("food") || command.contains("الطعام") {
                self.navigateToNature = true
            } else if command.contains("animals") || command.contains("الحيوانات") {
                self.navigateToAnimals = true
            }
        }
    }
}
