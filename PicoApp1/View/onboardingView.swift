import SwiftUI
import Speech

class OnboardingViewModel: ObservableObject {
    @Published var navigateToCategories = false
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()

    // قائمة الأوامر الصوتية المدعومة
    var voiceCommands: [String] = ["start", "begin", "go", "ابدأ"] // يمكنك إضافة المزيد من الأوامر هنا

    func startListening() {
        // طلب إذن لاستخدام التعرف على الصوت
        SFSpeechRecognizer.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self.record()
                }
            } else {
                print("لم يتم منح إذن التعرف على الصوت.")
            }
        }
    }

    private func record() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("التعرف على الصوت غير متاح.")
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        request.shouldReportPartialResults = true

        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                print("حدث خطأ أثناء التعرف على الصوت: \(error.localizedDescription)")
                return
            }

            if let result = result {
                let spokenText = result.bestTranscription.formattedString.lowercased()
                print("تم التعرف على النص: \(spokenText)")

                // التحقق إذا كان النص موجودًا في قائمة الأوامر
                if self.voiceCommands.contains(spokenText.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    DispatchQueue.main.async {
                        self.navigateToCategories = true
                    }
                }
            }
        }

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        do {
            try audioEngine.start()
            print("بدأ الاستماع...")
        } catch {
            print("تعذر بدء تشغيل محرك الصوت: \(error.localizedDescription)")
        }
    }

    func stopListening() {
        audioEngine.stop()
        recognitionTask?.cancel()
        print("توقف الاستماع.")
    }
}

struct onboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: -20) {
                Text("welcome to pico!")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(Color("font1"))
                
                ZStack {
                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 880.0, height: 326)
                        .scaleEffect(x: -1)
                        .offset(x: -20, y: -20)
                    
                    Text("Say the category you want to color")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.font1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .offset(x: -20, y: -20)
                    
                    Image("Pico")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 115, height: 115)
                        .padding(.leading, 910.0)
                        .padding(.top, 90.0)
                }
                
                Image(systemName: "mic.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 366, height: 350)
                    .foregroundColor(.brave)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.inspire)
                        .frame(width: 398, height: 90)
                        .offset(x: 4, y: 4)
                    
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.binspire)
                        .frame(width: 398, height: 90)
                    
                    NavigationLink(destination: CategoriesScreen(), isActive: $viewModel.navigateToCategories) {
                        HStack {
                            
                            
                            Text("Start")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                            
                          
                        }
                        .padding(.horizontal, 80)
                    }
                }
                .padding(.top, 40)
            }
        }
        .onAppear {
            viewModel.startListening()
        }
    }
}


#Preview {
    onboardingView()
}
