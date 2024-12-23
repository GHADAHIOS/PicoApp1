import SwiftUI
import Speech
import AVFoundation

struct DrawingsScreen3: View {
    @State private var navigateToCategories = false
    @State private var navigateToColoring1 = false
    @State private var navigateToColoring2 = false
    @State private var navigateToColoring3 = false
    @State private var navigateToColoring4 = false
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var clickedCard: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?

    let voiceCommands = ["one", "two", "three", "four", "categories"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // Header Section
                    HStack {
                        VStack {
                            Button(action: {
                                playBubbleSound()
                                navigateToCategories = true
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
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                                    .offset(x: -80, y: -20)
                            }
                        }
                    }
                    .padding(.top, -30)

                    Spacer()

                    // Cards Section
                    HStack(spacing: 10) {
                        ForEach(1...4, id: \.self) { number in
                            Button(action: {
                                playBubbleSound()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.5)) {
                                    clickedCard = number
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    clickedCard = nil
                                    navigateToColoring(number: number)
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.brave)
                                        .frame(width: 286, height: 350)
                                        .shadow(color: Color.brave.opacity(0.2), radius: 5, x: 0, y: 2)
                                        .scaleEffect(clickedCard == number ? 1.1 : 1.0)

                                    VStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 238.33, height: 256.13)

                                        Text("\(number)")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                    }
                                }
                            }
                            .opacity(clickedCard == nil || clickedCard == number ? 1.0 : 0.3) // Fade unselected cards
                            .zIndex(clickedCard == number ? 1 : 0) // Selected card on top
                        }
                    }
                    .padding(.bottom, 50)

                    Spacer()
                }
            }
            .onAppear {
                startListening()
            }
            .onDisappear {
                stopRecording()
            }
            .navigationDestination(isPresented: $navigateToCategories) {
                CategoriesScreen()
            }
            .navigationDestination(isPresented: $navigateToColoring1) {
                PixelArtView()
            }
            .navigationDestination(isPresented: $navigateToColoring2) {
                ColoringScreen()
            }
            .navigationDestination(isPresented: $navigateToColoring3) {
                ColoringScreen()
            }
            .navigationDestination(isPresented: $navigateToColoring4) {
                ColoringScreen()
            }
        }
    }

    func navigateToColoring(number: Int) {
        switch number {
        case 1: navigateToColoring1 = true
        case 2: navigateToColoring2 = true
        case 3: navigateToColoring3 = true
        case 4: navigateToColoring4 = true
        default: break
        }
    }

    func playBubbleSound() {
        guard let soundURL = Bundle.main.url(forResource: "bubble", withExtension: "m4a") else {
            print("Sound file not found!")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }

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

    func startAudioEngine() throws {
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
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

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        isRecording = false
    }

    func handleVoiceCommand(_ command: String) {
        if command.contains("one") || command.contains("واحد") {
            navigateToColoring1 = true
        } else if command.contains("two") || command.contains("اثنين") {
            navigateToColoring2 = true
        } else if command.contains("three") || command.contains("ثلاثة") {
            navigateToColoring3 = true
        } else if command.contains("four") || command.contains("أربعة") {
            navigateToColoring4 = true
        } else if command.contains("categories") || command.contains("الفئات") {
            navigateToCategories = true
        }
    }
}// MARK: - Preview
struct DrawingsScreen3_Previews: PreviewProvider {
    static var previews: some View {
        DrawingsScreen3()
    }
}
