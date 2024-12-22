import SwiftUI
import Speech

struct CategoriesScreen: View {
    @State private var isArabic: Bool = false // Language toggle (English by default)
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    // Available voice commands
    let voiceCommands = ["space", "food", "animals"]

    // Navigation states
    @State private var navigateToSpace = false
    @State private var navigateToNature = false
    @State private var navigateToAnimals = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // Top section: cloud, language button, and character
                    HStack {
                        VStack(spacing: 5) {
                            // Language toggle button
                            Button(action: {
                                isArabic.toggle() // Toggle language state
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.inspire)
                                        .frame(width: 77, height: 73)
                                        .offset(x: 2, y: 2)

                                    Circle()
                                        .fill(Color.binspire)
                                        .frame(width: 77, height: 73)
                                        .padding(.all, 5)

                                    Image(systemName: "globe")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.white)
                                }
                            }

                            // Text below the language toggle button
                            Text("العربية")
                                .font(.headline)
                                .foregroundColor(.font1)
                        }
                        .padding(.leading, 25)
                        .padding(.top, -100)

                        Spacer()

                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .offset(x: -80, y: 50)

                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 880.0, height: 326)
                                    .scaleEffect(x: -1) // Flip the cloud horizontally
                                    .offset(x: -80, y: -20)

                                Text("Say the category you want to color")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 50)
                                    .offset(x: -80, y: -20)
                            }
                        }
                    }
                    .padding(.top, -30)

                    Spacer()

                    // The three category cards
                    HStack(spacing: 20) {
                        NavigationLink(destination: DrawingsScreen3(), isActive: $navigateToSpace) {
                            VStack {
                                Text("Space")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Image("space")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 241.26, height: 213)
                                    .padding()
                            }
                            .frame(width: 340, height: 400)
                            .background(Color.brave)
                            .cornerRadius(18)
                            .shadow(color: Color.brave.opacity(0.5), radius: 10, x: 0, y: 3)
                        }

                        NavigationLink(destination: DrawingsScreen2(), isActive: $navigateToNature) {
                            VStack {
                                Text("Food")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Image("food")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 241.26, height: 213)
                                    .padding()
                            }
                            .frame(width: 340, height: 400)
                            .background(Color.hope)
                            .cornerRadius(18)
                            .shadow(color: Color.hope.opacity(0.5), radius: 10, x: 0, y: 3)
                        }

                        NavigationLink(destination: DrawingsScreen(), isActive: $navigateToAnimals) {
                            VStack {
                                Text("Animals")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                Image("animal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 241.26, height: 213)
                                    .padding()
                            }
                            .frame(width: 340, height: 400)
                            .background(Color.shine)
                            .cornerRadius(18)
                            .shadow(color: Color.shine.opacity(0.5), radius: 10, x: 0, y: 3)
                        }
                    }
                    .padding(.bottom, 78)

                    Spacer()
                }
            }
            .onAppear {
                startListening() // Start listening when the screen appears
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
        }
    }

    // Start listening for voice commands
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                do {
                    try startAudioEngine()
                } catch {
                    print("Audio engine error: \(error)")
                }
            }
        }
    }

    // Activate the audio engine and process speech
    func startAudioEngine() throws {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))! // English only
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                handleVoiceCommand(result.bestTranscription.formattedString)
            }

            if error != nil {
                stopRecording()
            }
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
    }

    // Stop recording
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        isRecording = false
    }

    // Handle voice commands
    func handleVoiceCommand(_ command: String) {
        if command.contains("space") {
            navigateToSpace = true
        } else if command.contains("food") {
            navigateToNature = true
        } else if command.contains("animals") {
            navigateToAnimals = true
        }
    }
}

// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
