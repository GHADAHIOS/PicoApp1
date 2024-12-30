import SwiftUI
import Speech
import AVFoundation
class CategoriesViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var selectedCategory: String? = nil
    @Published var navigateToDrawingsScreen = false
    @Published var clickedCard: String? = nil
    
    private var audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    
    // قائمة الأوامر الصوتية
    var voiceCommands: [String] {
        return [ "space", "food", "animals"]
    }
    
    let categories: [Category] = [
        Category(name: "Space", imageName: "earth", color: Color.shine),
        Category(name: "Food", imageName: "dounat", color: Color.hope),
        Category(name: "Animals", imageName: "butterflycoloring", color: Color.brave),
        Category(name: "Animals", imageName: "butterflycoloring", color: Color.brave)
    ]
    
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self.startRecording()
                case .denied:
                    print("Speech recognition authorization denied.")
                case .restricted:
                    print("Speech recognition is restricted on this device.")
                case .notDetermined:
                    print("Speech recognition authorization not determined.")
                @unknown default:
                    print("Unknown speech recognition authorization status.")
                }
            }
        }
    }
    
    private func startRecording() {
        guard !audioEngine.isRunning else { return }
        
        // إعداد الجلسة الصوتية
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("Failed to configure audio session: \(error.localizedDescription)")
//            return
//        }
//
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
            return
        }
        
        
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request.")
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let command = result.bestTranscription.formattedString
                print("Heard command: \(command)")
                self.handleVoiceCommand(command)
            }
            
            if let error = error {
                print("Recognition task error: \(error.localizedDescription)")
                self.stopRecording()
            }
            
            if result?.isFinal == true {
                self.stopRecording()
            }
        }
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0) // تنظيف أي تبويبات قديمة
        
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        do {
            try audioEngine.start()
            isRecording = true
            print("Audio engine started, now listening.")
        } catch {
            print("Failed to start audio engine: \(error.localizedDescription)")
            stopRecording()
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecording = false
        print("Stopped recording.")
    }
    
    func handleVoiceCommand(_ command: String) {
        // مقارنة الأوامر مع التصنيفات
        let normalizedCommand = command.lowercased()
        if let category = categories.first(where: { $0.name.lowercased() == normalizedCommand }) {
            selectCategory(category.name)
        } else if let category = categories.first(where: { _ in voiceCommands.contains(normalizedCommand) }) {
            selectCategory(category.name)
        } else {
            print("Command not recognized: \(command)")
        }
    }
    
    func selectCategory(_ category: String) {
        clickedCard = category
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.clickedCard = nil
            self.selectedCategory = category
            self.navigateToDrawingsScreen = true
        }
    }
}
