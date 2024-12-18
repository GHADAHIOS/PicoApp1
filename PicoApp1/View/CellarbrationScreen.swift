import SwiftUI
import Speech
import AVFoundation

struct CellarbrationScreen: View {
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)
    
    // حالات التنقل بين الشاشات
    @State private var navigateToCategories = false
    @State private var navigateToColoring = false
    
    // الأوامر الصوتية التي سيتم التعرف عليها
    let voiceCommands = ["فئات", "تلوين", "حفظ", "مشاركة", "حذف", "categories", "coloring", "save", "share", "delete"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.BG)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button(action: {
                            navigateToCategories = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.inspire)
                                    .frame(width: 100, height: 100)
                                    .offset(x: 3, y: 3)
                                
                                Circle()
                                    .fill(Color.binspire)
                                    .frame(width: 100, height: 100)
                                    .padding(.all, 5)
                                
                                Image(systemName: "circle.grid.2x2")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.leading, 25.0)
                        .overlay(
                            Text("Category")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .offset(x: 10, y: 70)
                        )
                        Spacer(minLength: 12)
                        
                        Button(action: {
                            navigateToColoring = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.inspire)
                                    .frame(width: 100, height: 100)
                                    .offset(x: 3, y: 3)
                                
                                Circle()
                                    .fill(Color.binspire)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "paintbrush.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 45.0)
                        .overlay(
                            Text("Colorings")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.trailing, 45.0)
                                .offset(y: 70)
                        )
                    }
                    .padding(.top, 30)
                    
                    ZStack {
                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .offset(x: -10, y: 40)
                            
                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 780.0, height: 326)
                                    .offset(x: -90, y: -80)
                                
                                Text("Well done, genius! Keep going!")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 50)
                                    .offset(x: -90, y: -80)
                            }
                        }
                        .padding(.top, -30)
                    }
                    .padding(.top, -100)
                    
                    // حفظ
                    Button(action: {
                        saveToGallery()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.bhope)
                                .frame(width: 398, height: 90)
                                .offset(x: 4, y: 4)
                            
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.hope)
                                .frame(width: 398, height: 90)
                            
                            HStack {
                                Image(.image3)
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.bottom, 50)
                                HStack {
                                    Text("Save")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    
                                    Image(systemName: "square.and.arrow.down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                                }
                                .padding(.horizontal, 80)
                                
                                Image(.image3)
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.bottom, 50)
                            }
                        }
                    }
                    
                    // زر المشاركة
                    Button(action: {
                        shareDrawing()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.inspire)
                                .frame(width: 398, height: 90)
                                .offset(x: 4, y: 4)
                            
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.binspire)
                                .frame(width: 398, height: 90)
                            
                            HStack {
                                Image(.image2)
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.bottom, 50)
                                HStack {
                                    Text("Share")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    
                                    Image(systemName: "square.and.arrow.up")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                                }
                                .padding(.horizontal, 80)
                                
                                Image(.image2)
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.bottom, 50)
                            }
                        }
                    }
                    
                    // زر الحذف
                    Button(action: {
                        deleteDrawing()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.bBrave)
                                .frame(width: 398, height: 90)
                                .offset(x: 4, y: 4)
                            
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.brave)
                                .frame(width: 398, height: 90)
                            
                            HStack {
                                Image(.image1)
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.bottom, 50)
                                HStack {
                                    Text("Delete")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                                    
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                                }
                                .padding(.horizontal, 80)
                                
                                Image(.image1)
                                    .resizable()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.bottom, 50)
                            }
                        }
                    }
                }
                .padding(.bottom, 130)
                
                // الانتقال إلى الصفحات باستخدام NavigationLink
                NavigationLink(
                    destination: CategoriesScreen(), // صفحة الفئات
                    isActive: $navigateToCategories
                ) { EmptyView() }

                NavigationLink(
                    destination: ColoringScreen(), // صفحة التلوين
                    isActive: $navigateToColoring
                ) { EmptyView() }
            }
            .onAppear {
                startListening() // بدء الاستماع عند فتح الشاشة
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
        }
    }

    // Start listening for voice commands
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    do {
                        try startAudioEngine()
                    } catch {
                        print("Audio engine error: \(error)")
                    }
                } else {
                    print("Speech recognition authorization denied.")
                }
            }
        }
    }

    func startAudioEngine() throws {
        audioEngine = AVAudioEngine()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }

    // معالجة الأوامر الصوتية
    func handleVoiceCommand(_ command: String) {
        let lowercasedCommand = command.lowercased()

        if voiceCommands.contains(lowercasedCommand) {
            switch lowercasedCommand {
            case "فئات", "categories":
                navigateToCategories = true
            case "تلوين", "coloring":
                navigateToColoring = true
            case "حفظ", "save":
                saveToGallery()
            case "مشاركة", "share":
                shareDrawing()
            case "حذف", "delete":
                deleteDrawing()
            default:
                print("Unrecognized command: \(command)")
            }
        }
    }

    func saveToGallery() {
        print("Image saved to gallery.")
    }

    func shareDrawing() {
        print("Image shared.")
    }

    func deleteDrawing() {
        print("Drawing deleted.")
    }
}


// Preview
#Preview {
    CellarbrationScreen()
}
