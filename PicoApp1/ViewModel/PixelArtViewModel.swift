//
//  PixelArtView.swift
//  PJson
//
//  Created by Ashwaq on 24/06/1446 AH.
//

import SwiftUI
import SwiftData
import Speech
import AVFoundation


class PixelArtViewModel: UIView , SFSpeechRecognizerDelegate ,ObservableObject{
    var pixelArt: PixelArt
    var selectedColor: UIColor
    var selectedNumber: Int?
    var cellColors: [[UIColor?]] // Stores the selected color for each cell
    var onColorChanged: (() -> Void)? // Closure to notify color changes
   // @Environment(\.modelContext) private var modelContext
    var modelContext: ModelContext // Store the model context
    
    @State private var selectedCategory: Category?
    @State private var selectedCard: Category?

 //   @Published var isRecording = false

    
//        private var speechRecognizer: SFSpeechRecognizer?
//        private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
//        private var recognitionTask: SFSpeechRecognitionTask?
//        private var audioEngine: AVAudioEngine?
//        
//    // قائمة الأوامر الصوتية
////    var voiceCommands: [String] {
////        return [ "space", "food", "animals"]
////    }
    
    
    init(frame: CGRect, pixelArt: PixelArt, selectedColor: UIColor, modelContext: ModelContext) {
         self.pixelArt = pixelArt
         self.selectedColor = selectedColor
         self.cellColors = Array(repeating: Array(repeating: nil, count: pixelArt.width), count: pixelArt.height)
         self.modelContext = modelContext // Assign the model context
         super.init(frame: frame)
        
//        // Initialize the speech recognizer with the appropriate locale
//             self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))
//             self.speechRecognizer?.delegate = self

     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func startListening() {
//        SFSpeechRecognizer.requestAuthorization { authStatus in
//            DispatchQueue.main.async {
//                switch authStatus {
//                case .authorized:
//                    self.startRecording()
//                case .denied:
//                    print("Speech recognition authorization denied.")
//                case .restricted:
//                    print("Speech recognition is restricted on this device.")
//                case .notDetermined:
//                    print("Speech recognition authorization not determined.")
//                @unknown default:
//                    print("Unknown speech recognition authorization status.")
//                }
//            }
//        }
//    }
    
    
//    private func startRecording() {
//        print("startRecording")
//        guard !audioEngine!.isRunning else { return }
//        
//        // إعداد الجلسة الصوتية
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("Failed to configure audio session: \(error.localizedDescription)")
//            return
//        }
//        
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        guard let recognitionRequest = recognitionRequest else {
//            print("Unable to create recognition request.")
//            return
//        }
//        recognitionRequest.shouldReportPartialResults = true
//        
//        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
//            if let result = result {
//                let command = result.bestTranscription.formattedString
//                print("Heard command: \(command)")
//                self.handleRecognizedCommand(command)
//            }
//            
//            if let error = error {
//                print("Recognition task error: \(error.localizedDescription)")
//                self.stopRecording()
//            }
//            
//            if result?.isFinal == true {
//                self.stopRecording()
//            }
//        }
//        
//        let inputNode = audioEngine?.inputNode
//        inputNode?.removeTap(onBus: 0) // تنظيف أي تبويبات قديمة
//        let recordingFormat = inputNode?.outputFormat(forBus: 0)
//        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
//            self.recognitionRequest?.append(buffer)
//        }
//        
//        do {
//            try audioEngine?.start()
//            isRecording = true
//            print("Audio engine started, now listening.")
//        } catch {
//            print("Failed to start audio engine: \(error.localizedDescription)")
//            stopRecording()
//        }
//    }
    
    
//    func stopRecording() {
//        audioEngine?.stop()
//        audioEngine?.inputNode.removeTap(onBus: 0)
//        recognitionRequest?.endAudio()
//        recognitionTask?.cancel()
//        recognitionTask = nil
//        isRecording = false
//        print("Stopped recording.")
//    }

//        func handleRecognizedCommand(_ command: String) {
//            print("Recognized command: \(command)")
//
//            let words = command.lowercased().split(separator: " ")
//            
//            if words.contains("color") {
//                if let colorName = getColorFromCommand(words) {
//                    self.selectedColor = colorName
//                    print("Selected color: \(colorName)")
//                }
//            }
//            
//            if words.contains("number") {
//                if let number = getNumberFromCommand(words) {
//                    self.selectedNumber = number
//                    print("Selected number: \(number)")
//                }
//            }
//            
//            if words.contains("apply") {
//                applyColorToSelectedPixels()
//            }
//        }
//        
//        func getColorFromCommand(_ words: [Substring]) -> UIColor? {
//            // This function can be extended to handle more colors
//            let colorMapping: [String: UIColor] = [
//                "red": .red,
//                "blue": .blue,
//                "green": .green,
//                "yellow": .yellow,
//                "purple": .purple,
//                "orange": .orange
//            ]
//            
//            for word in words {
//                if let color = colorMapping[String(word)] {
//                    return color
//                }
//            }
//            return nil
//        }
//        
//        func getNumberFromCommand(_ words: [Substring]) -> Int? {
//            for word in words {
//                if let number = Int(word) {
//                    return number
//                }
//            }
//            return nil
//        }
//
//    
//    func applyColorToSelectedPixels() {
//     print("applyColorToSelectedPixels")
//    }

    
    func savePixelArtToDatabase(pixelArt: PixelArt) {
            do {
                // Insert the updated pixel art into the model context and save it
                modelContext.insert(pixelArt)
                try modelContext.save()  // Save the context to persist the data
                print("Pixel art updated successfully!")
            } catch {
                print("Error saving updated pixel art: \(error)")
            }
        }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let pixelWidth = rect.width / CGFloat(pixelArt.width)
        let pixelHeight = rect.height / CGFloat(pixelArt.height)
        
        for row in 0..<pixelArt.height {
            for col in 0..<pixelArt.width {
                let colorHex = pixelArt.pixels[row][col]
                guard let color = UIColor(hex: colorHex) else { continue }

                let fillColor: UIColor
                if let selected = cellColors[row][col] {
                    fillColor = selected // If user has selected a color for this pixel, use that
                } else {
                    fillColor = color // Otherwise, use the original color from the pixelArt
                }
                
                fillColor.setFill() // Set the fill color
                let pixelRect = CGRect(x: CGFloat(col) * pixelWidth, y: CGFloat(row) * pixelHeight, width: pixelWidth, height: pixelHeight)
                let pixelPath = UIBezierPath(rect: pixelRect)
                pixelPath.fill() // Draw the pixel
                
                // Optionally, if there's a number to display
                if let number = pixelArt.numbers?[row][col] {
                    let text = "\(number)"
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: 12),
                        .foregroundColor: UIColor.black
                    ]
                    let string = NSString(string: text)
                    string.draw(in: pixelRect, withAttributes: attributes)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        let pixelWidth = self.bounds.width / CGFloat(pixelArt.width)
        let pixelHeight = self.bounds.height / CGFloat(pixelArt.height)
        
        let col = Int(touchLocation.x / pixelWidth)
        let row = Int(touchLocation.y / pixelHeight)
        
        // Ensure the touch is within bounds
        if col >= 0 && col < pixelArt.width && row >= 0 && row < pixelArt.height {
            let cellNumber = pixelArt.numbers?[row][col]
            
            // Dynamically set the selected number based on the cell tapped
            if let tappedNumber = cellNumber {
                selectedNumber = tappedNumber
            }
            
            // Handle the coloring logic based on the selected number
            if let selectedNumber = selectedNumber {
                // Color only the cells that have the same number as the selected one
                for r in 0..<pixelArt.height {
                    for c in 0..<pixelArt.width {
                        if let number = pixelArt.numbers?[r][c], number == selectedNumber {
                            cellColors[r][c] = selectedColor // Color matching cells
                            pixelArt.pixels[r][c] = selectedColor.toHex() // Update the pixel color
                        }
                    }
                }
            }
            
            // Notify that a color change occurred
            onColorChanged?()
            savePixelArtToDatabase(pixelArt: pixelArt)

            // Redraw the view to reflect the changes
            setNeedsDisplay()
        }
    }
  
    
    
}


