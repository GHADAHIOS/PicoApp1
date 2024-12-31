import SwiftUI
import Speech
import AVFoundation

struct Pick: View {
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var navigateToColoring1 = false
    @State private var navigateToColoring2 = false
    @State private var navigateToColoring3 = false
    @State private var navigateToColoring4 = false
    @State private var clickedCard: Int? = nil
    @State private var audioPlayer: AVAudioPlayer?

    let cardColors: [Color] = [.shine, .hope, .brave, .binspire]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // واجهة المستخدم العلوية (الشعار والنص)
                    HStack {
                        HStack {
                         
                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 713, height: 126)
                                    .scaleEffect(x: -1)
//                                    .padding(.bottom, 38.0)
                    Text("قل رقم الرسم للتلوين")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                            }
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .padding(.top, 80)
                                .padding(.leading, -40.0)

                            
                        }
                        .padding(.horizontal, 1000)
                        .padding(.top, 80)
                    }

                    Spacer(minLength: 20)

                    // بطاقات الأرقام
                    HStack(spacing: 10) {
                        ForEach(1...4, id: \ .self) { number in
                            Button(action: {
                                playBubbleSound()
                                clickedCard = number
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    clickedCard = nil
                                    navigateToColoring(number: number)
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(cardColors[number - 1])
                                        .frame(width: 286, height: 350)
                                        .shadow(color: cardColors[number - 1].opacity(0.2), radius: 5)
                                        .scaleEffect(clickedCard == number ? 1.2 : 1.0)

                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white)
                                        .frame(width: 240, height: 250)

                                    Text("\(number)")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.top, 290.0)

                                }
                                .padding(.bottom, 242.0)
                            }
                            .opacity(clickedCard == nil || clickedCard == number ? 1.0 : 0.3)
                            .padding(.top, clickedCard == number ? 0 : 50)
                        }
                    }

                    Spacer()
                }
            }
            .onAppear {
                startListening() // بدء الاستماع للأوامر الصوتية
            }
            .navigationDestination(isPresented: $navigateToColoring1) {
                PixelArtDynmicView(fileName: "Animals_3")
            }
            .navigationDestination(isPresented: $navigateToColoring2) {
                PixelArtDynmicView(fileName: "Food_1")
            }
            .navigationDestination(isPresented: $navigateToColoring3) {
                PixelArtDynmicView(fileName: "pixelart")
            }
            .navigationDestination(isPresented: $navigateToColoring4) {
                PixelArtDynmicView(fileName: "")
            }
        }
    }

    // التنقل بناءً على الرقم
    func navigateToColoring(number: Int) {
        playBubbleSound()
        clickedCard = number
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            clickedCard = nil
            switch number {
            case 1: navigateToColoring1 = true
            case 2: navigateToColoring2 = true
            case 3: navigateToColoring3 = true
            case 4: navigateToColoring4 = true
            default: break
            }
        }
    }

    // تشغيل صوت الفقاعة
    func playBubbleSound() {
        guard let soundURL = Bundle.main.url(forResource: "bubble", withExtension: "m4a") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }

    // بدء الاستماع للأوامر الصوتية
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                do {
                    let node = audioEngine.inputNode
                    let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-SA"))
                    
                    recognitionRequest.shouldReportPartialResults = true
                    self.recognitionRequest = recognitionRequest
                    
                    self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                        if let result = result {
                            let spokenText = result.bestTranscription.formattedString
                            handleVoiceCommand(spokenText)
                        }
                        if error != nil || result?.isFinal == true {
                            self.audioEngine.stop()
                            node.removeTap(onBus: 0)
                            self.isRecording = false
                            self.startListening() // إعادة تشغيل الاستماع عند الانتهاء
                        }
                    }
                    
                    let recordingFormat = node.outputFormat(forBus: 0)
                    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                        recognitionRequest.append(buffer)
                    }
                    
                    self.audioEngine.prepare()
                    try self.audioEngine.start()
                    self.isRecording = true
                } catch {
                    print("Error starting audio engine: \(error)")
                }
            } else {
                print("Speech recognition not authorized")
            }
        }
    }

    // التعامل مع الأوامر الصوتية
    func handleVoiceCommand(_ command: String) {
        DispatchQueue.main.async {
            if command.contains("واحد") || command.contains("1") {
                navigateToColoring(number: 1)
            } else if command.contains("اثنان") || command.contains("2") {
                navigateToColoring(number: 2)
            } else if command.contains("ثلاثة") || command.contains("3") {
                navigateToColoring(number: 3)
            } else if command.contains("أربعة") || command.contains("4") {
                navigateToColoring(number: 4)
            } else {
                print("لم يتم التعرف على الأمر: \(command)")
            }
        }
    }
}

// MARK: - Preview
struct Pick_Previews: PreviewProvider {
    static var previews: some View {
        Pick()
    }
}
