import SwiftUI
import Speech

struct CategoriesScreen: View {
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)
    @State private var speechRecognizer: SFSpeechRecognizer? // التعرف الصوتي
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    @State private var audioEngine = AVAudioEngine()
    @State private var navigateToDrawings: Bool = false // التحكم في التنقل
    @State private var selectedColor: Color = .white // اللون الافتراضي للكروت

    var body: some View {
        ZStack {
            // خلفية الصفحة
            Color.BG.edgesIgnoringSafeArea(.all)

            VStack {
                // القسم العلوي: السحابة + زر اللغة + الشخصية
                HStack {
                    // زر تغيير اللغة على اليسار
                    Button(action: {
                        isArabic.toggle() // تغيير حالة اللغة عند الضغط
                        toggleLanguage() // تغيير اللغة في التعرف الصوتي
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

                    Spacer()

                    // صورة السحابة مع الشخصية
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

                            Text(isArabic ? "قل اسم الفئة للانتقال" : "Say the category you would like to color")
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
                    Button(action: {
                        selectedColor = .orange // لون الفضاء
                        navigateToDrawings = true
                    }) {
                        categoryCard(title: "Space", imageName: "space", color: Color.brave)
                    }
                    Button(action: {
                        selectedColor = .blue // لون الطبيعة
                        navigateToDrawings = true
                    }) {
                        categoryCard(title: "Nature", imageName: "food", color: Color.hope)
                    }
                    Button(action: {
                        selectedColor = .yellow // لون الحيوانات
                        navigateToDrawings = true
                    }) {
                        categoryCard(title: "Animals", imageName: "animal", color: Color.shine)
                    }
                }
                .padding(.bottom, 78)

                Spacer()
            }

            // التنقل إلى صفحة DrawingsScreen
            NavigationLink(
                destination: DrawingsScreen(cardColor: selectedColor),
                isActive: $navigateToDrawings,
                label: { EmptyView() }
            )
        }
        .onAppear { setupSpeechRecognition() } // إعداد ميزة التحكم الصوتي عند فتح الصفحة
        .onDisappear { stopListening() } // إيقاف الاستماع عند مغادرة الصفحة
    }
    
    private func categoryCard(title: String, imageName: String, color: Color) -> some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 241.26, height: 213)
                .padding()
        }
        .frame(width: 340, height: 400)
        .background(color)
        .cornerRadius(18)
        .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 3)
    }

    // MARK: - Speech Recognition Setup
    private func setupSpeechRecognition() {
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: isArabic ? "ar-SA" : "en-US"))
                startListening() // بدء الاستماع مباشرة
            } else {
                print("Speech recognition authorization failed.")
            }
        }
    }
    
    private func startListening() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer is not available.")
            return
        }
        
        let inputNode = audioEngine.inputNode
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, _ in
            self.recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine could not start: \(error.localizedDescription)")
        }
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let command = result.bestTranscription.formattedString.lowercased()
                handleVoiceCommand(command)
            }
            
            if error != nil || result?.isFinal == true {
                self.restartListening() // إعادة تشغيل الاستماع إذا توقف
            }
        }
    }
    
    private func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    private func restartListening() {
        stopListening()
        startListening()
    }
    
    private func handleVoiceCommand(_ command: String) {
        if command.contains(isArabic ? "فضاء" : "space") {
            selectedColor = .orange
            navigateToDrawings = true
        } else if command.contains(isArabic ? "طبيعة" : "nature") {
            selectedColor = .blue
            navigateToDrawings = true
        } else if command.contains(isArabic ? "حيوانات" : "animals") {
            selectedColor = .yellow
            navigateToDrawings = true
        } else if command.contains(isArabic ? "عربي" : "arabic") || command.contains(isArabic ? "إنجليزي" : "english") {
            toggleLanguage()
        }
    }
    
    private func toggleLanguage() {
        isArabic.toggle()
        stopListening()
        setupSpeechRecognition()
        print("Language switched to \(isArabic ? "Arabic" : "English")")
    }
}
// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
