import SwiftUI
import Speech

struct CategoriesScreen: View {
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    // الأوامر الصوتية المتاحة
    let voiceCommands = ["فضاء", "طبيعة", "حيوانات", "تغيير اللغة", "change language"] // تم إضافة أمر تغيير اللغة

    // حالات التنقل بين الشاشات
    @State private var navigateToSpace = false
    @State private var navigateToNature = false
    @State private var navigateToAnimals = false

    var body: some View {
        NavigationStack {
            ZStack {
                // خلفية الصفحة
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // القسم العلوي: السحابة + زر اللغة + الشخصية
                    HStack {
                        // زر تغيير اللغة على اليسار
                        Button(action: {
                            isArabic.toggle() // تغيير حالة اللغة عند الضغط
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
                        .padding(.leading, 25)
                        .padding(.top, -100)

                        // النص أسفل زر تغيير اللغة
                        VStack {
                            Text(isArabic ? "تغيير اللغة" : "Change Language")
                                .font(.headline)
                                .foregroundColor(.font1)
                                .padding(.top, 5)
                        }

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
                                    .offset(x: -80, y: -20)

                                Text(isArabic ? "قل الفئة التي تريد تلوينها" : "Say the category you want to color")
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

                    // الكروت الثلاثة في المنتصف
                    HStack(spacing: 20) {
                        NavigationLink(destination: DrawingsScreen3(), isActive: $navigateToSpace) {
                            VStack {
                                Text(isArabic ? "فضاء" : "Space")
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
                                Text(isArabic ? "طبيعة" : "Nature")
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
                                Text(isArabic ? "حيوانات" : "Animals")
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
                startListening() // بدء الاستماع عند فتح الشاشة
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
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
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: isArabic ? "ar_SA" : "en_US"))! // اللغة تتغير بناءً على الحالة
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
        if command.contains("فضاء") || command.contains("space") {
            navigateToSpace = true
        } else if command.contains("طبيعة") || command.contains("nature") {
            navigateToNature = true
        } else if command.contains("حيوانات") || command.contains("animals") {
            navigateToAnimals = true
        } else if command.contains("تغيير اللغة") || command.contains("change language") {
            isArabic.toggle() // تغيير اللغة إذا تم التعرف على الأمر
        }
    }
}// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
