import SwiftUI
import AVFoundation
import Speech

struct DrawingsScreen: View {
    var selectedCategory: String // Passed from CategoriesScreen
    @State private var clickedCard: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?

    @State private var navigateToCategories = false
    @State private var navigateToColoring = false
    
    @State private var isRecording = false
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))

    // قائمة الأوامر الصوتية
    var voiceCommands: [String] {
        return ["one", "two", "three", "four", "categories"]
    }

    // Dynamic color for each category
    func categoryColor() -> Color {
        switch selectedCategory {
        case "Space": return Color.shine
        case "Food": return Color.hope
        case "Animals": return Color.brave
        default: return Color.gray
        }
    }

    // Dynamic images for each category
    func categoryImages() -> [String] {
        switch selectedCategory {
        case "Space": return ["Space1", "Space2", "space3", "space4"]
        case "Food": return ["food1", "food2", "food3", "food4"]
        case "Animals": return ["butterfly1", "cat2", "Giraffe1", "penguin"]
        default: return []
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        VStack {
                            Button(action: {
                                navigateToCategories = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue) // Outer circle color
                                        .frame(width: 77, height: 73)
                                        .offset(x: 2, y: 2)

                                    Circle()
                                        .fill(Color.blue) // Inner circle color
                                        .frame(width: 77, height: 73)
                                        .padding(.all, 5)

                                    Image(systemName: "circle.grid.2x2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.white)
                                }
                            }
                            Text("Categories")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.top, 5)
                        }
                        .padding(.leading, 25)
                        .padding(.top, -100)

                        Spacer()

                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .scaleEffect(x: -1)
                                .offset(x: -80, y: 50)

                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 880.0, height: 326)
                                    .scaleEffect(x: -1)
                                    .offset(x: -80, y: -20)
                                Text("Say a drawing number to color")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1) // Text color
                                    .multilineTextAlignment(.center)
                                    .offset(x: -80, y: -20)
                            }
                        }
                    }
                    .padding(.top, -30)

                    Spacer()

                    HStack(spacing: 10) {
                        let images = categoryImages()

                        ForEach(1...4, id: \.self) { number in
                            Button(action: {
                                playBubbleSound()
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    clickedCard = number
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    clickedCard = nil
                                    navigateToColoring = true
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(categoryColor()) // Dynamic background color
                                        .frame(width: 286, height: 350)
                                        .shadow(color: categoryColor().opacity(0.2), radius: 5, x: 0, y: 2)
                                        .scaleEffect(clickedCard == number ? 1.2 : 1.0)
                                    VStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 238.33, height: 266.13)
                                    }

                                    VStack {
                                        if number - 1 < images.count {
                                            Image(images[number - 1]) // Dynamically load images for the category
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 208.33, height: 276.13)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .shadow(radius: 5)
                                                .padding(.top, 5) // Adjust the top padding
                                        }
                                    }

                                    VStack {
                                        Text("\(number)")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 310) // Adjust the top padding
                                    }
                                }
                            }
                            .opacity(clickedCard == nil || clickedCard == number ? 1.0 : 0.3)
                            .padding(.top, clickedCard == number ? 0 : 50)
                            .zIndex(clickedCard == number ? 1 : 0)
                        }
                    }
                    .padding(.bottom, 50)

                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)

            .navigationDestination(isPresented: $navigateToCategories) {
                CategoriesScreen()
            }
            .navigationDestination(isPresented: $navigateToColoring) {
                PixelArtView()
            }
        }
        .onAppear {
            startListening() // Start listening automatically when the view appears
        }
    }

    // Start listening for voice commands
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.startRecording() // Start recording if permission is granted
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

        let audioEngine = AVAudioEngine()
        let inputNode = audioEngine.inputNode

        inputNode.removeTap(onBus: 0)

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let command = result.bestTranscription.formattedString
                self.handleVoiceCommand(command)
            }

            if error != nil || result?.isFinal == true {
                audioEngine.stop()
                recognitionRequest.endAudio()
                recognitionTask?.cancel()
                recognitionTask = nil
                startRecording() // Re-start listening after each command
            }
        }

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { (buffer, _) in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    // Handle the recognized voice command
    func handleVoiceCommand(_ command: String) {
        // مقارنة الأوامر الصوتية مع الأوامر المحددة
        let commandLowercased = command.lowercased()

        // التحقق من الأوامر الصوتية
        if commandLowercased == "one" {
            clickedCard = 1
        } else if commandLowercased == "two" {
            clickedCard = 2
        } else if commandLowercased == "three" {
            clickedCard = 3
        } else if commandLowercased == "four" {
            clickedCard = 4
        } else if commandLowercased == "categories" {
            navigateToCategories = true
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
}
// MARK: - Preview
struct DrawingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DrawingsScreen(selectedCategory: "Space")
    }
}
