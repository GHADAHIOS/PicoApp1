import SwiftUI
import Speech
import AVFoundation

class onboardingViewModel: ObservableObject {
    @Published var navigateToCategories = false
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()

    // قائمة الأوامر الصوتية المدعومة
    var voiceCommands: [String] = ["start", "begin", "go", "ابدأ"] // يمكنك إضافة المزيد من الأوامر هنا

    // طلب إذن لاستخدام التعرف على الصوت
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.record()
                } else {
                    print("لم يتم منح إذن التعرف على الصوت.")
                }
            }
        }
    }

    // إعداد وبدء التسجيل
    private func record() {
        // التأكد من أن SFSpeechRecognizer متاح
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("التعرف على الصوت غير متاح.")
            return
        }

        // إعداد AVAudioSession
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("فشل في إعداد AVAudioSession: \(error.localizedDescription)")
            return
        }

        // إعداد طلب التعرف على الصوت
        let request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        request.shouldReportPartialResults = true

        // تحقق من تنسيق الصوت
        let format = inputNode.outputFormat(forBus: 0)
        guard format.sampleRate > 0 && format.channelCount > 0 else {
            print("تنسيق الصوت غير صالح: SampleRate=\(format.sampleRate), ChannelCount=\(format.channelCount)")
            stopListening()
            return
        }

        // إزالة التبويبات القديمة
        inputNode.removeTap(onBus: 0)

        // تثبيت التبويب الجديد
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        // بدء مهمة التعرف على الصوت
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

        // بدء محرك الصوت
        do {
            try audioEngine.start()
            print("بدأ الاستماع...")
        } catch {
            print("تعذر بدء تشغيل محرك الصوت: \(error.localizedDescription)")
        }
    }

    // إيقاف الاستماع
    func stopListening() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)  // إزالة التبويب
        recognitionTask?.cancel()
        recognitionTask = nil
        print("توقف الاستماع.")
    }
}

struct onboardingView: View {
    @StateObject private var viewModel = onboardingViewModel()

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
                    
                    Text("Say Start")
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
