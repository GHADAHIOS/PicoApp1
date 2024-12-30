import SwiftUI
import Speech
import AVFoundation

struct Pick: View {
    // حالة للتسجيل وبدء الاستماع للأوامر الصوتية
    @State private var isRecording = false
    // إعدادات محرك الصوت الذي يقوم بتسجيل الصوت
    @State private var audioEngine = AVAudioEngine()
    // المهمة التي تتعامل مع نتائج التعرف على الصوت
    @State private var recognitionTask: SFSpeechRecognitionTask?
    // الطلب الذي يرسل البيانات لمحرك التعرف على الصوت
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    // حالات للتنقل بين الشاشات بناءً على الأوامر الصوتية
    @State private var navigateToCategories = false
    @State private var navigateToColoring1 = false
    @State private var navigateToColoring2 = false
    @State private var navigateToColoring3 = false
    @State private var navigateToColoring4 = false

    // الحالة التي تتحكم في الكرت الذي تم النقر عليه
    @State private var clickedCard: Int? = nil
    // متغير لتشغيل الصوت عند النقر
    @State private var audioPlayer: AVAudioPlayer?

    // الأوامر الصوتية المتوقعة
    let voiceCommands = ["واحد", "اثنان", "ثلاثة", "أربعة"]
    // ألوان الكروت
    let cardColors: [Color] = [.shine, .hope, .brave, .binspire]

    var body: some View {
        NavigationStack {
            ZStack {
                // خلفية التطبيق
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // واجهة المستخدم العلوية (الشعار والنص)
                    HStack {
                        Spacer()
                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .offset(x: 820, y: 50)

                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 880.0, height: 326)
                                    .scaleEffect(x: -1)
                                    .offset(x: -170, y: -20)
                                Text("قل رقم الرسم للتلوين")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                                    .offset(x: -170, y: -20)
                            }
                        }
                    }
                    .padding(.top, -30)

                    Spacer()

                    // عرض الكروت التي يمكن للمستخدم اختيارها
                    HStack(spacing: 10) {
                        ForEach(1...4, id: \.self) { number in
                            Button(action: {
                                playBubbleSound() // تشغيل صوت الفقاعة عند النقر
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    clickedCard = number
                                }
                                // بعد تأخير بسيط، الانتقال إلى الشاشة الخاصة بالرقم المختار
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    clickedCard = nil
                                    navigateToColoring(number: number)
                                }
                            }) {
                                ZStack {
                                    // تصميم الكرت مع تأثير الظل
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(cardColors[number - 1])
                                        .frame(width: 286, height: 350)
                                        .shadow(color: cardColors[number - 1].opacity(0.2), radius: 5, x: 0, y: 2)
                                        .scaleEffect(clickedCard == number ? 1.2 : 1.0)

                                    VStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 238.33, height: 256.13)

                                        // عرض الرقم على الكرت
                                        Text("\(number)")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
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
            // عند ظهور الواجهة، يتم تشغيل الصوت ثم بدء الاستماع
            .onAppear {
                playOnAppearSound {
                    startListening() // بدء الاستماع للأوامر الصوتية
                }
            }
            // التنقل بين الشاشات بناءً على الأوامر الصوتية
            .navigationDestination(isPresented: $navigateToCategories) {
                PixelArtDynmicView(fileName: "Animals_1")
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

    // دالة للتنقل إلى الشاشة الصحيحة بناءً على الرقم المختار
    func navigateToColoring(number: Int) {
        switch number {
        case 1: navigateToColoring1 = true
        case 2: navigateToColoring2 = true
        case 3: navigateToColoring3 = true
        case 4: navigateToColoring4 = true
        default: break
        }
    }

    // دالة لتشغيل صوت الفقاعة عند النقر على الكرت
    func playBubbleSound() {
        guard let soundURL = Bundle.main.url(forResource: "bubble", withExtension: "m4a") else {
            print("Sound file not found!") // في حال عدم وجود ملف الصوت
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play() // تشغيل الصوت
        } catch {
            print("Error playing sound: \(error)") // في حال حدوث خطأ أثناء التشغيل
        }
    }

    // دالة لتشغيل الصوت عند ظهور الشاشة
    func playOnAppearSound(completion: @escaping () -> Void) {
        guard let soundURL = Bundle.main.url(forResource: "Hi", withExtension: "mp3") else {
            print("Sound file not found!") // في حال عدم وجود ملف الصوت
            completion()
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            // بعد انتهاء الصوت، يتم استدعاء الـ completion
            DispatchQueue.main.asyncAfter(deadline: .now() + audioPlayer!.duration) {
                completion()
            }
        } catch {
            print("Error playing onAppear sound: \(error)") // في حال حدوث خطأ أثناء التشغيل
            completion()
        }
    }

    // دالة لبدء الاستماع للأوامر الصوتية
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                do {
                    let node = audioEngine.inputNode
                    let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
                    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-SA"))
                    
                    recognitionRequest.shouldReportPartialResults = true
                    self.recognitionRequest = recognitionRequest
                    
                    // بدء مهمة التعرف على الصوت
                    self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                        if let result = result {
                            let spokenText = result.bestTranscription.formattedString
                            print("تم التعرف على النص: \(spokenText)")  // طباعة النص للـ debug
                            handleVoiceCommand(spokenText) // التعامل مع النص المتعرف عليه
                        }

                        // في حال حدوث خطأ أو تم التعرف على النص بالكامل
                        if error != nil || result?.isFinal == true {
                            self.audioEngine.stop()
                            node.removeTap(onBus: 0)
                            self.isRecording = false
                        }
                    }
                    
                    // إعداد شكل التسجيل
                    let recordingFormat = node.outputFormat(forBus: 0)
                    node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                        recognitionRequest.append(buffer) // إضافة البيانات للتعرف
                    }
                    
                    self.audioEngine.prepare()
                    try self.audioEngine.start() // بدء محرك الصوت
                    self.isRecording = true
                } catch {
                    print("Error starting audio engine: \(error)") // في حال حدوث خطأ أثناء بدء المحرك
                }
            } else {
                print("فشل في الحصول على تصريح للتعرف على الصوت")
            }
        }
    }

    // دالة للتعامل مع الأوامر الصوتية
    func handleVoiceCommand(_ command: String) {
        DispatchQueue.main.async {
            switch command {
            case "واحد":
                navigateToColoring1 = true
            case "اثنان":
                navigateToColoring2 = true
            case "ثلاثة":
                navigateToColoring3 = true
            case "أربعة":
                navigateToColoring4 = true
            default:
                print("لم يتم التعرف على الأمر: \(command)") // إذا لم يتعرف على الأمر
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
