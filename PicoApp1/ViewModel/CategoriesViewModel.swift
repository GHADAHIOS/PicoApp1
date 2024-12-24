import SwiftUI
import Speech
import AVFoundation

class CategoriesViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var selectedCategory: String? = nil
    @Published var navigateToDrawingsScreen = false
    @Published var clickedCard: String? = nil
    
    private var audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
    
    // قائمة الأوامر الصوتية باللغة العربية والإنجليزية
    var voiceCommands: [String] {
        return ["الفضاء", "الطعام", "الحيوانات", "space", "food", "animals"]
    }
    
    let categories: [Category] = [
        Category(name: "Space", imageName: "space", color: Color.shine),
        Category(name: "Food", imageName: "food", color: Color.hope),
        Category(name: "Animals", imageName: "animals", color: Color.brave)
    ]
    
    init() {
        // التهيئة
    }
    
    func startListening() {
        // طلب صلاحية الوصول إلى التعرف على الصوت
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                self.startRecording() // بدء التسجيل الصوتي إذا كانت الصلاحية متاحة
            case .denied, .restricted, .notDetermined:
                print("Speech recognition authorization denied or not available")
            default:
                break
            }
        }
    }
    
    private func startRecording() {
        // إعداد الجلسة الصوتية
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        audioEngine.inputNode.removeTap(onBus: 0)
        
        // إعداد مهمة التعرف الصوتي
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let command = result.bestTranscription.formattedString
                self.handleVoiceCommand(command) // معاملة الأمر الصوتي
            }
            if error != nil || result?.isFinal == true {
                self.stopRecording() // إيقاف التسجيل عند الانتهاء
            }
        }
        
        // ربط المدخلات الصوتية بالطلب
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { (buffer, _) in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start() // بدء الاستماع
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    func handleVoiceCommand(_ command: String) {
        // مقارنة الأوامر الصوتية مع التصنيفات
        if let category = categories.first(where: { $0.name.lowercased() == command.lowercased() || $0.name == command }) {
            selectCategory(category.name) // تحديد التصنيف
        }
    }
    
    func selectCategory(_ category: String) {
        clickedCard = category
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.clickedCard = nil
            self.selectedCategory = category
            self.navigateToDrawingsScreen = true
        }
    }
}
