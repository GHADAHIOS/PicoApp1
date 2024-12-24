//import Foundation
//import Speech
//import AVFoundation
//import PhotosUI
//
//class CellarbrationScreenViewModel: ObservableObject {
//    @Published var model: CellarbrationScreenModel
//    @Published var isRecording = false
//    @Published var audioEngine = AVAudioEngine()
//    @Published var recognitionTask: SFSpeechRecognitionTask?
//    @Published var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//    
//    // الأوامر الصوتية
//    let voiceCommands = ["فئات", "تلوين", "حفظ", "مشاركة", "حذف", "categories", "coloring", "save", "share", "delete"]
//    
//    init(image: UIImage?) {
//        self.model = CellarbrationScreenModel(image: image, isArabic: true)
//    }
//
//    func startListening() {
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            DispatchQueue.main.async {
//                if authStatus == .authorized {
//                    do {
//                        try self.startAudioEngine()
//                    } catch {
//                        print("Audio engine error: \(error)")
//                    }
//                } else {
//                    print("Speech recognition authorization denied.")
//                }
//            }
//        }
//    }
//
//    private func startAudioEngine() throws {
//        audioEngine = AVAudioEngine()
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        let inputNode = audioEngine.inputNode
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
//            self.recognitionRequest?.append(buffer)
//        }
//
//        audioEngine.prepare()
//        try audioEngine.start()
//        isRecording = true
//    }
//
//    func stopRecording() {
//        audioEngine.stop()
//        recognitionRequest?.endAudio()
//    }
//
//    func handleVoiceCommand(_ command: String) {
//        let lowercasedCommand = command.lowercased()
//        if voiceCommands.contains(lowercasedCommand) {
//            switch lowercasedCommand {
//            case "فئات", "categories":
//                model.navigateToCategories = true
//            case "تلوين", "coloring":
//                model.navigateToColoring = true
//            case "حفظ", "save":
//                saveToGallery()
//            case "مشاركة", "share":
//                shareDrawing()
//            case "حذف", "delete":
//                deleteDrawing()
//            default:
//                print("Unrecognized command.")
//            }
//        }
//    }
//
//    func saveToGallery() {
//        guard let image = model.image else {
//            print("No image to save.")
//            return
//        }
//        PHPhotoLibrary.requestAuthorization { status in
//            if status == .authorized {
//                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                print("Saved successfully.")
//            }
//        }
//    }
//
//    func shareDrawing() {
//        print("Sharing the drawing.")
//    }
//
//    func deleteDrawing() {
//        print("Deleting the drawing.")
//    }
//}
