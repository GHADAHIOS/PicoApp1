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

struct PixelArtViewRepresentable: UIViewRepresentable {
    var pixelArt: PixelArt
    var selectedNumber: Int?
    var selectedColor: UIColor
    var onColorChanged: (() -> Void)?
    var modelContext: ModelContext

    func makeUIView(context: Context) -> PixelArtViewModel {
        let view = PixelArtViewModel(frame: .zero, pixelArt: pixelArt, selectedColor: selectedColor, modelContext: modelContext)
        return view
    }

    func updateUIView(_ uiView: PixelArtViewModel, context: Context) {
        uiView.pixelArt = pixelArt
        uiView.selectedColor = selectedColor
        uiView.selectedNumber = selectedNumber
        uiView.setNeedsDisplay() // Redraw the view with the new data
    }
}

struct PixelArtDynmicView: View {
    @State private var pixelArt: PixelArt? // PixelArt state (optional)
    @State private var selectedColor: Color = .blue
    @Environment(\.modelContext) private var modelContext // Access the model context
    @State private var showDetailView = false // Control navigation

    private let colorOptions: [Color] = [ .red, .green, .blue]
    private let availablePixelArtFiles = ["pixelart", "pixelart2", "pixelart3"]

    var body: some View {
        NavigationStack {
            VStack {
                
                // Top section with buttons on both sides
                

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
                                .offset(x: -170, y: 10)
                            Text("Say a drawing number to color")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.font1)
                                .multilineTextAlignment(.center)
                                .offset(x: -170, y: 15)
                        }
                    }
                }
                
                HStack{
                    // Pixel art display and editing
                    if let pixelArt = pixelArt {
                        PixelArtViewRepresentable(
                            pixelArt: pixelArt,
                            selectedColor: UIColor(self.selectedColor),
                            modelContext: modelContext
                        )
                        .frame(width: 650, height: 650) // زيادة حجم الإطار
                        
                        .border(Color.black, width: 1)
                       .padding(.leading, 350)
                       .padding(.bottom, 200)
                    }
                    
                    // Color selection buttons and Save button
                    VStack(spacing: 30) {
                        ForEach(colorOptions, id: \.self) { color in
                            Button(action: {
                                self.selectedColor = color
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .stroke(Color.white, lineWidth: 6)
                                        .frame(width: 70, height: 70)
                                        .shadow(color: Color.black, radius: 1)
                                }
                            }
                            
                        }
                    //    .padding(.leading,36)
                        // Save and navigate button
                        VStack {
                            // رفع الزر
                            
                            Button(action: {
                                if let pixelArt = pixelArt {
                                    savePixelArtToDatabase(pixelArt: pixelArt)
                                    showDetailView = true // إعداد الانتقال بعد الحفظ
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
                                                .frame(width: 100, height: 100)
                                                .offset(x: 3, y: 3)
                                            
                                            Circle()
                                                .fill(Color.green)
                                                .frame(width: 100, height: 100)
                                                .padding(5)
                                        }
                                    )
                            }
                            
                          
                            
                        }
                        
                        NavigationLink(destination: UpdatePixelArtView(pixelArt: $pixelArt), isActive: $showDetailView) {
                            EmptyView() // رابط التنقل المخفي
                        }
                    }.padding(.leading, 50)
                }
                .padding(.horizontal, 20)
            }
            .padding()
            .onAppear {
                if let firstFile = availablePixelArtFiles.first {
                    self.loadPixelArt(from: firstFile)
                }
            }
            .navigationBarBackButtonHidden(true)
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
