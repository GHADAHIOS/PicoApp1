import Foundation
import SwiftUI
import AVFoundation
import Speech

class DrawingsViewModel: ObservableObject {
    @Published var clickedCard: Int? = nil
    @Published var navigateToCategories = false
    @Published var navigateToColoring = false
    @Published var isRecording = false

    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    private var audioPlayer: AVAudioPlayer?

    var selectedCategory: String
    var voiceCommands: [String] {
        return ["one", "two", "three", "four", "categories"]
    }

    init(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        //print("selectedCategory",selectedCategory)
    }
    
    //new to save select art number //
    @Published var selectedArt: String? {
        didSet {
            // Save the selected category to UserDefaults
            if let selectedArt = selectedArt {
                UserDefaults.standard.set(selectedArt, forKey: "selectedArt")
            }
        }
    }
    
    func categoryColor() -> Color {
        switch selectedCategory {
        case "Space": return Color.shine
        case "Food": return Color.hope
        case "Animals": return Color.brave
        default: return Color.gray
        }
    }

    func categoryImages() -> [String] {
        switch selectedCategory {
        case "Space": return ["space1", "STARSHIP", "rocketbw", "space4"]
        case "Food": return ["strawberryBW", "pizzeBW", "donutBW", "food4"]
        case "Animals": return ["butterfly1", "cat2", "Giraffe1", "penguin"]
        default: return []
        }
    }

    func playBubbleSound() {
        guard let soundURL = Bundle.main.url(forResource: "bubble", withExtension: "m4a") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }

    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.startRecording()
            case .denied, .restricted, .notDetermined:
                print("Speech recognition authorization denied or not available")
            default:
                break
            }
        }
    }

    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = recognitionRequest else {
            return
        }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode

        inputNode.removeTap(onBus: 0)

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let command = result.bestTranscription.formattedString
                self.handleVoiceCommand(command)
            }

            if error != nil || result?.isFinal == true {
                self.audioEngine.stop()
                recognitionRequest.endAudio()
                self.recognitionTask?.cancel()
                self.recognitionTask = nil
                self.startRecording() // Restart listening
            }
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    private func handleVoiceCommand(_ command: String) {
        let commandLowercased = command.lowercased()

        switch commandLowercased {
        case "one":
            clickedCard = 1
            navigateToColoring = true
        case "two":
            clickedCard = 2
            navigateToColoring = true
        case "three":
            clickedCard = 3
            navigateToColoring = true
        case "four":
            clickedCard = 4
            navigateToColoring = true
        case "categories":
            navigateToCategories = true
        default:
            break
        }
    }
}
