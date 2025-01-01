
import SwiftUI
import SwiftData
import UIKit
import Speech
import AVFoundation

extension UIColor {
    convenience init?(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }

        var rgb: UInt64 = 0
        if scanner.scanHexInt64(&rgb) {
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else {
            return nil
        }
    }

    func toHex() -> String {
        guard let components = self.cgColor.components else {
            return "#000000"
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}


struct PixelArtViewRepresentable: UIViewRepresentable {
    var pixelArt: PixelArt
    var selectedColor: UIColor
    var modelContext: ModelContext
    @State var fileName: String
    
    // Mapping numbers to colors (you can customize this mapping)
    var colorMapping: [Int: UIColor] // Make sure it's a dictionary, not a type
    
    func makeUIView(context: Context) -> PixelArtViewModel {
        // Pass the actual colorMapping dictionary to PixelArtViewModel
        let view = PixelArtViewModel(
            frame: .zero,
            pixelArt: pixelArt,
            selectedColor: selectedColor,
            modelContext: modelContext,
            colorMapping: colorMapping // Pass dictionary instance here
        )
        return view
    }
    
    func updateUIView(_ uiView: PixelArtViewModel, context: Context) {
        // Update the PixelArtViewModel when data changes
        uiView.pixelArt = pixelArt
        uiView.selectedColor = selectedColor
        uiView.colorMapping = colorMapping // Ensure the mapping is updated as well
        uiView.setNeedsDisplay() // Redraw the view to reflect changes
    }
}



struct PixelArtDynmicView: View {
    @State private var pixelArt: PixelArt? // PixelArt state (optional)
    @State private var selectedColor: Color = .blue
    @Environment(\.modelContext) private var modelContext // Access the model context
    @State private var showDetailView = false // Control navigation
    var fileName: String // Pixel art file name
    
    private let colorOptions: [Color] = [.red, .green, .blue , .orange]
    @State private var speechRecognizedText: String = ""
    @State private var speechRecognizer: SFSpeechRecognizer? // Speech recognizer initialized later
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var isRecording = false // Track whether recording is active

    // Initializer
    init(fileName: String) {
        self.fileName = fileName
        // Initialize the speech recognizer for Arabic (Saudi Arabia)
        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ar-SA"))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    ZStack {
                        Image("cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 713, height: 126)
                            .scaleEffect(x: -1)
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
                .padding(.top, 190)
                
                HStack {
                    if let pixelArt = pixelArt {
                        PixelArtViewRepresentable(
                            pixelArt: pixelArt,
                            selectedColor: UIColor(self.selectedColor),
                            modelContext: modelContext,
                            fileName: "pixelart",
                            colorMapping: [Int: UIColor]()
                        )
                        .frame(width: 600, height: 600)
                        .border(Color.black, width: 1)
                        .padding(.leading, 300)
                        .padding(.bottom, 200)
                    }
                    
                    VStack(spacing: 30) {
                        ForEach(colorOptions, id: \.self) { color in
                            Button(action: {
                                self.selectedColor = color
                                self.colorAllPixels(withColor: color) // Call colorAllPixels when a color is selected
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 60, height: 60)
                                    
                                    Circle()
                                        .stroke(Color.white, lineWidth: 6)
                                        .frame(width: 60, height: 60)
                                        .shadow(color: Color.black, radius: 1)
                                }
                            }
                        }
                        NavigationLink(destination: CellarbrationScreen(pixelArt: $pixelArt), isActive: $showDetailView) {
                            
                            Button(action: {
                                if let pixelArt = pixelArt {
                                    savePixelArtToDatabase(pixelArt: pixelArt)
                                    showDetailView = true
                                }
                            }) {
                                Image(systemName: "checkmark")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 200)
                                    .background(
                                        ZStack {
                                            Circle()
                                                .fill(Color.green1)
                                                .frame(width: 90, height: 90)
                                                .offset(x: 3, y: 3)
                                            
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width: 90, height: 90)
                                                .padding(5)
                                        }
                                    )
                            }
                        }
                        
//                       }
//                        NavigationLink(destination: CellarbrationScreen(pixelArt: $pixelArt), isActive: $showDetailView) {
//                            EmptyView() // رابط التنقل المخفي
                        
                    }.padding(.leading, 50)
                }
                .padding(.bottom, 50)
               // .padding(.horizontal, 20)
            }
            .padding()
            .onAppear {
                self.loadPixelArt(from: fileName)
                self.setupAudioSession()  // Configure the audio session when the view appears
                self.startListening()  // Start listening for voice commands
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: speechRecognizedText) { newCommand in
                // Call the handleVoiceCommand method when the recognized speech changes
                handleVoiceCommandV(newCommand)
            }
        }
    }
    
    func loadPixelArt(from fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Failed to find \(fileName).json in the app bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let pixelArt = try decoder.decode(PixelArt.self, from: data)
            self.pixelArt = pixelArt
        } catch {
            print("Error decoding pixel art JSON: \(error)")
        }
    }
    
    func savePixelArtToDatabase(pixelArt: PixelArt) {
        do {
            modelContext.insert(pixelArt)
            try modelContext.save()
            print("Pixel art saved successfully!")
        } catch {
            print("Error saving pixel art: \(error)")
        }
    }
    
    // Set up the audio session for speech recognition
    func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            print("Audio session is set up successfully.")
        } catch {
            print("Failed to set up the audio session: \(error)")
        }
    }
    
    // Start listening for speech commands in Arabic
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
                            self.speechRecognizedText = spokenText // Update the recognized text
                        }
                        
                        // Check if error or task has finished
                        if error != nil || result?.isFinal == true {
                            self.audioEngine.stop()
                            node.removeTap(onBus: 0)
                            self.isRecording = false
                            
                            // After finishing the task, restart the listening process
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.startListening() // Restart listening for new commands
                            }
                        }
                    }
                    
                    // Use the input node's output format (this automatically ensures compatibility)
                    let recordingFormat = node.outputFormat(forBus: 0)
                    
                    // Install the tap with the correct format
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

    
    
    // Stop any ongoing listening session
    func stopListening() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            print("Audio engine stopped.")
        }
     else {
           print("Audio engine already stopped.")
       }
    }

    func removeDuplicateWords(from command: String) -> String {
        let words = command.split { !$0.isLetter }
        let uniqueWords = Set(words.map { String($0) })
        return uniqueWords.joined(separator: " ")
    }
    
    @State private var lastProcessedCommandTime: Date? = nil
    let debounceInterval: TimeInterval = 0.5  // Adjust this interval to suit your needs

    func handleVoiceCommandV(_ command: String) {
        // Trim leading/trailing whitespace and make case-insensitive check
        var trimmedCommand = removeDuplicateWords(from: command)

        DispatchQueue.main.async {
            // Debugging: print the command received for analysis
            guard !command.isEmpty else { return }

            print("Received command: \(trimmedCommand)")

            let currentTime = Date()
                
            // Check if enough time has passed since the last command
            if let lastProcessedCommandTime = lastProcessedCommandTime,
               currentTime.timeIntervalSince(lastProcessedCommandTime) < debounceInterval {
                return // Ignore this command if it's too soon after the last one
            }
                
            // Match the Arabic commands and some English commands to select the color
            if trimmedCommand.contains("واحد") || trimmedCommand.contains("1") {
                self.selectedColor = .red
                print("تم اختيار اللون الأحمر") // Arabic: Red color selected
                if let pixelArt = self.pixelArt {
                    self.colorAllPixels(withColor: .red) // Trigger the coloring with red
                }
            } else if trimmedCommand.contains("اثنان") || trimmedCommand.contains("2") {
                self.selectedColor = .green
                print("تم اختيار اللون الأخضر") // Arabic: Green color selected
                if let pixelArt = self.pixelArt {
                    self.colorAllPixels(withColor: .green) // Trigger the coloring with green
                }
            } else if trimmedCommand.contains("ثلاثة") || trimmedCommand.contains("3") {
                self.selectedColor = .blue
                print("تم اختيار اللون الأزرق") // Arabic: Blue color selected
                if let pixelArt = self.pixelArt {
                    self.colorAllPixels(withColor: .blue) // Trigger the coloring with blue
                   
                }
            } else if trimmedCommand.contains("ابدأ التلوين") || trimmedCommand.contains("start coloring") {
                // Trigger coloring logic when the user says "ابدأ التلوين" or "start coloring"
                if let pixelArt = self.pixelArt {
                    self.colorAllPixels(withColor: self.selectedColor) // Use the current selected color
                }
                print("تم بدء التلوين") // Arabic: Coloring started
            } else if trimmedCommand.contains("حفظ") || trimmedCommand.contains("save") {
                if let pixelArt = self.pixelArt {
                    self.savePixelArtToDatabase(pixelArt: pixelArt)
                    self.showDetailView = true
                    print("تم حفظ العمل") // Arabic: Work saved
                }
            } else {
                // If none of the conditions are met, just print the command.
                print("Unrecognized command: \(trimmedCommand)")
                trimmedCommand = ""
            }
            self.speechRecognizedText = "" // Clear the recognized command to reset
            trimmedCommand = ""
                   // Update the time of the last processed command for debounce logic
            lastProcessedCommandTime = currentTime
        }
    }
    
    func colorAllPixels(withColor color: Color) {
        guard let pixelArt = pixelArt else { return }

        // Convert the SwiftUI Color to UIColor
        let uiColor = UIColor(color) // Convert the Color to UIColor
        
        // Get the hex string representation of the color
        let hexColor = uiColor.toHex()
        print("hexColor", hexColor)
        // Map each color to a specific pixel number
        var pixelNumberToColorMapping: [Color: Int] = [
            .red: 1,     // Red corresponds to pixel number 1
            .blue: 2,    // Blue corresponds to pixel number 2
            .green: 3,   // Green corresponds to pixel number 3
            .orange: 4,  // orange corresponds to pixel number 4 (if you want to add more colors)
            // Add more colors if needed
        ]
        
        // Find the pixel number for the selected color
        guard let pixelNumber = pixelNumberToColorMapping[color] else {
            print("No mapping found for the selected color")
            return
        }

        // Loop through all the pixels and color them based on the pixel number
        for row in 0..<pixelArt.height {
            for col in 0..<pixelArt.width {
                let currentPixelNumber = pixelArt.numbers![row][col]
                
                // If the pixel number matches the selected pixel number, color it
                if currentPixelNumber == pixelNumber {
                    pixelArt.pixels[row][col] = hexColor // Update the pixel color
                }
            }
        }
    }
}


#Preview {
    PixelArtDynmicView(fileName: "pixelart")
}
