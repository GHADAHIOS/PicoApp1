import SwiftUI
import Speech

struct DrawingsScreen2: View {
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)
    @State private var navigateToCategories = false
    @State private var navigateToColoring1 = false
    @State private var navigateToColoring2 = false
    @State private var navigateToColoring3 = false
    @State private var navigateToColoring4 = false
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    // قائمة الأوامر الصوتية
    let voiceCommands = ["واحد", "اثنان", "ثلاثة", "أربعة", "الفئات", "categories"]

    var body: some View {
        NavigationStack {
            ZStack {
                // خلفية الصفحة
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // القسم العلوي: السحابة + زر اللغة + الشخصية
                    HStack {
                        // زر تغيير اللغة مع النص
                        VStack {
                            Button(action: {
                                navigateToCategories = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.inspire) // لون رمادي شفاف
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
                            
                            // النص تحت الزر
                            Text(isArabic ? "الفئات" : "Categories")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.top, 5) // مسافة صغيرة بين الزر والنص
                        }
                        .padding(.leading, 25)
                        .padding(.top, -100)

                        Spacer()

                        // السحابة مع الشخصية
                        HStack {
                            // الشخصية
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
                                    .offset(x: -80, y: -20)
                                // النص في السحابة
                                Text(isArabic ? "قل رقم الرسم لتلوينه" : "Say a drawing number to color")
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

                    // الكروت الكبيرة في منتصف الشاشة
                    HStack(spacing: 10) {
                        ForEach((1...4).reversed(), id: \.self) { number in
                            Button(action: {
                                navigateToColoring(number: number)
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(Color.hope) // استخدام لون hope مباشرة
                                        .frame(width: 286, height: 350)
                                        .shadow(color: Color.hope.opacity(0.2), radius: 5, x: 0, y: 2)

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
                        }
                    }
                    .padding(.bottom, 50)

                    Spacer()
                }
            }
            .onAppear {
                startListening() // بدء الاستماع للأوامر الصوتية
            }
            .navigationDestination(isPresented: $navigateToCategories) {
                CategoriesScreen()
            }
            .navigationDestination(isPresented: $navigateToColoring1) {
                ColoringScreen()
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

    // التنقل بناءً على الرقم
    func navigateToColoring(number: Int) {
        switch number {
        case 1: navigateToColoring1 = true
        case 2: navigateToColoring2 = true
        case 3: navigateToColoring3 = true
        case 4: navigateToColoring4 = true
        default: break
        }
    }

    // بدء الاستماع للأوامر الصوتية
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

    // تفعيل محرك الصوت وتحليل الصوت
    func startAudioEngine() throws {
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: isArabic ? "ar_SA" : "en_US"))!
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
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

    // إيقاف التسجيل
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        isRecording = false
    }

    // التعامل مع الأوامر الصوتية
    func handleVoiceCommand(_ command: String) {
        let lowercasedCommand = command.lowercased()

        if lowercasedCommand.contains("واحد") || lowercasedCommand.contains("1") {
            navigateToColoring(number: 1)
        } else if lowercasedCommand.contains("اثنان") || lowercasedCommand.contains("2") {
            navigateToColoring(number: 2)
        } else if lowercasedCommand.contains("ثلاثة") || lowercasedCommand.contains("3") {
            navigateToColoring(number: 3)
        } else if lowercasedCommand.contains("أربعة") || lowercasedCommand.contains("4") {
            navigateToColoring(number: 4)
        } else if lowercasedCommand.contains("الفئات") || lowercasedCommand.contains("categories") {
            navigateToCategories = true
        }
    }
}

// MARK: - Preview
struct DrawingsScreen2_Previews: PreviewProvider {
    static var previews: some View {
        DrawingsScreen2()
    }
}
