import SwiftUI
import SwiftData
import UIKit


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


//class PixelArtView: UIView {
//    var pixelArt: PixelArt
//    var selectedColor: UIColor
//    var selectedNumber: Int?
//    var cellColors: [[UIColor?]] // Stores the selected color for each cell
//    var onColorChanged: (() -> Void)? // Closure to notify color changes
//   // @Environment(\.modelContext) private var modelContext
//    var modelContext: ModelContext // Store the model context
//
//    
//    init(frame: CGRect, pixelArt: PixelArt, selectedColor: UIColor, modelContext: ModelContext) {
//         self.pixelArt = pixelArt
//         self.selectedColor = selectedColor
//         self.cellColors = Array(repeating: Array(repeating: nil, count: pixelArt.width), count: pixelArt.height)
//         self.modelContext = modelContext // Assign the model context
//         super.init(frame: frame)
//     }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func savePixelArtToDatabase(pixelArt: PixelArt) {
//            do {
//                // Insert the updated pixel art into the model context and save it
//                modelContext.insert(pixelArt)
//                try modelContext.save()  // Save the context to persist the data
//                print("Pixel art updated successfully!")
//            } catch {
//                print("Error saving updated pixel art: \(error)")
//            }
//        }
//    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        let pixelWidth = rect.width / CGFloat(pixelArt.width)
//        let pixelHeight = rect.height / CGFloat(pixelArt.height)
//        
//        for row in 0..<pixelArt.height {
//            for col in 0..<pixelArt.width {
//                let colorHex = pixelArt.pixels[row][col]
//                guard let color = UIColor(hex: colorHex) else { continue }
//
//                let fillColor: UIColor
//                if let selected = cellColors[row][col] {
//                    fillColor = selected // If user has selected a color for this pixel, use that
//                } else {
//                    fillColor = color // Otherwise, use the original color from the pixelArt
//                }
//                
//                fillColor.setFill() // Set the fill color
//                let pixelRect = CGRect(x: CGFloat(col) * pixelWidth, y: CGFloat(row) * pixelHeight, width: pixelWidth, height: pixelHeight)
//                let pixelPath = UIBezierPath(rect: pixelRect)
//                pixelPath.fill() // Draw the pixel
//                
//                // Optionally, if there's a number to display
//                if let number = pixelArt.numbers?[row][col] {
//                    let text = "\(number)"
//                    let attributes: [NSAttributedString.Key: Any] = [
//                        .font: UIFont.systemFont(ofSize: 12),
//                        .foregroundColor: UIColor.black
//                    ]
//                    let string = NSString(string: text)
//                    string.draw(in: pixelRect, withAttributes: attributes)
//                }
//            }
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        
//        let touchLocation = touch.location(in: self)
//        let pixelWidth = self.bounds.width / CGFloat(pixelArt.width)
//        let pixelHeight = self.bounds.height / CGFloat(pixelArt.height)
//        
//        let col = Int(touchLocation.x / pixelWidth)
//        let row = Int(touchLocation.y / pixelHeight)
//        
//        // Ensure the touch is within bounds
//        if col >= 0 && col < pixelArt.width && row >= 0 && row < pixelArt.height {
//            let cellNumber = pixelArt.numbers?[row][col]
//            
//            // Dynamically set the selected number based on the cell tapped
//            if let tappedNumber = cellNumber {
//                selectedNumber = tappedNumber
//            }
//            
//            // Handle the coloring logic based on the selected number
//            if let selectedNumber = selectedNumber {
//                // Color only the cells that have the same number as the selected one
//                for r in 0..<pixelArt.height {
//                    for c in 0..<pixelArt.width {
//                        if let number = pixelArt.numbers?[r][c], number == selectedNumber {
//                            cellColors[r][c] = selectedColor // Color matching cells
//                            pixelArt.pixels[r][c] = selectedColor.toHex() // Update the pixel color
//                        }
//                    }
//                }
//            }
//            
//            // Notify that a color change occurred
//            onColorChanged?()
//            savePixelArtToDatabase(pixelArt: pixelArt)
//
//            // Redraw the view to reflect the changes
//            setNeedsDisplay()
//        }
//    }
//  
//    
//    
//}

    

struct PixelArtViewRepresentable: UIViewRepresentable {
    var pixelArt: PixelArt
    var selectedNumber: Int?
    var selectedColor: UIColor
    var onColorChanged: (() -> Void)?
    var modelContext: ModelContext // Store the model context

    func makeUIView(context: Context) -> PixelArtViewModel {
        let view = PixelArtViewModel(frame: .zero, pixelArt: pixelArt, selectedColor: selectedColor, modelContext: modelContext)
        return view
    }

    func updateUIView(_ uiView: PixelArtViewModel, context: Context) {
        uiView.pixelArt = pixelArt
        uiView.selectedColor = selectedColor
        uiView.selectedNumber = selectedNumber
        uiView.setNeedsDisplay()  // Redraw the view with the new data
    }
}







struct PixelArtDynmicView: View {
    @State private var pixelArt: PixelArt? // PixelArt state (optional)
    @State private var selectedColor: Color = .blue
    @Environment(\.modelContext) private var modelContext // Access the model context
    @State private var showDetailView = false // Control navigation
    
    private let colorOptions: [Color] = [.blue, .red, .green, .yellow, .orange, .purple, .brown, .pink]
    private let availablePixelArtFiles = ["pixelart", "pixelart2", "pixelart3"]

    var body: some View {
        NavigationStack {
            VStack {
                Text("Pixel Art Editor")
                    .font(.title)
                    .padding()
                
                // Buttons for loading different pixel art files
                HStack {
                    ForEach(availablePixelArtFiles, id: \.self) { fileName in
                        Button(action: {
                            self.loadPixelArt(from: fileName)
                        }) {
                            Text(fileName)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                        .padding(4)
                    }
                }
                .padding()

                // Color selection buttons
                HStack {
                    ForEach(colorOptions, id: \.self) { color in
                        Button(action: {
                            self.selectedColor = color
                        }) {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                .padding(4)
                        }
                    }
                }
                .padding()
                
                // Pixel art display and editing
                if let pixelArt = pixelArt {
                    PixelArtViewRepresentable(
                        pixelArt: pixelArt,
                        selectedColor: UIColor(self.selectedColor),
                        modelContext: modelContext
                    )
                    .frame(width: 300, height: 300)
                    .border(Color.black, width: 1)
                    .padding()
                    
                    // Save button
                    Button("Save Pixel Art") {
                        savePixelArtToDatabase(pixelArt: pixelArt)
                    }
                    .padding()

                    // NavigationLink (conditionally unwrap pixelArt before passing to Binding)
//                    NavigationLink(destination: UpdatePixelArtView(pixelArt: $pixelArt)) {  // Force unwrap safely here
//                        Text("Go to Pixel Art List")
//                            .font(.headline)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
                    .padding()
                }
            }
            .padding()
            .onAppear {
                if let firstFile = availablePixelArtFiles.first {
                    self.loadPixelArt(from: firstFile)
                }
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
            print("Successfully loaded and decoded pixel art: \(fileName)")
        } catch {
            print("Error decoding pixel art JSON: \(error)")
        }
    }

    func savePixelArtToDatabase(pixelArt: PixelArt) {
        do {
            // Insert the pixel art into the model context and save it
            modelContext.insert(pixelArt)
            try modelContext.save()
            print("Pixel art saved successfully!")
        } catch {
            print("Error saving pixel art: \(error)")
        }
    }
}

#Preview {
    PixelArtDynmicView()
}
