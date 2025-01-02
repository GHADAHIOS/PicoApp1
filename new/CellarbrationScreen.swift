import SwiftUI
import SwiftData

struct CelebrationScreen: View {
    @StateObject private var viewModel = CellarbrationViewModel()
    @Query(sort: \PixelArt.id) var pixelArts: [PixelArt]
    @Environment(\.modelContext) private var modelContext
    @Binding var pixelArt: PixelArt?
    
    @State private var showConfetti = false // حالة لتفعيل تساقط القصاصات
    @State private var confettiPositions: [Confetti] = [] // لتخزين مواضع القصاصات
    
    var gridWidth: CGFloat = 400
    var gridHeight: CGFloat = 400
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.BG)
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Image("cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 700.0, height: 200)
                            .scaleEffect(x: -1)
                            .offset(x: -30, y: -20)
                        
                        Text("أحسنت عمل جميل ، إستمر يامبدع")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.font1)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                            .offset(x: -30, y: -20)
                        
                        Image("Pico")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 115, height: 115)
                            .padding(.leading, 710.0)
                            .padding(.top, 90.0)
                    }
                    .padding(.top, -100)
                    
                    if let pixelArt = pixelArt {
                        let pixelSize = min(gridWidth / CGFloat(pixelArt.width), gridHeight / CGFloat(pixelArt.height))
                        
                        VStack(spacing: 0) {
                            ForEach(0..<pixelArt.height, id: \.self) { row in
                                HStack(spacing: 0) {
                                    ForEach(0..<pixelArt.width, id: \.self) { col in
                                        let colorHex = pixelArt.pixels[row][col]
                                        if let color = UIColor(hex: colorHex) {
                                            Rectangle()
                                                .fill(Color(color))
                                                .frame(width: pixelSize, height: pixelSize)
                                        } else {
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(width: pixelSize, height: pixelSize)
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: gridWidth, height: gridHeight)
                        .padding(0)
                    } else {
                        Text("No Pixel Art found.")
                            .font(.title)
                            .padding()
                    }
                }
                .padding(.bottom, 130)
                
                // تساقط القصاصات الورقية
                ForEach(confettiPositions) { confetti in
                    Rectangle()
                        .fill(confetti.color)
                        .frame(width: 10, height: 10)
                        .position(confetti.position)
                        .opacity(showConfetti ? 1 : 0) // إظهار أو إخفاء القصاصات
                        .animation(.linear(duration: 2), value: showConfetti)
                }
            }
            .onAppear {
                startConfettiEffect() // بدء تأثير القصاصات تلقائيًا عند ظهور الشاشة
            }
            .onDisappear {
                stopConfettiEffect() // إيقاف تأثير القصاصات عند مغادرة الشاشة
            }
        }
    }
    
    // تشغيل تأثير تساقط القصاصات
    private func startConfettiEffect() {
        confettiPositions.removeAll()
        for _ in 0..<100 {
            let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0...UIScreen.main.bounds.height / 2)
            let color = Color.random()
            
            confettiPositions.append(Confetti(position: CGPoint(x: x, y: y), color: color))
        }
        
        showConfetti = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showConfetti = false // إخفاء القصاصات بعد 2 ثانية
        }
    }
    
    // إيقاف تأثير تساقط القصاصات
    private func stopConfettiEffect() {
        confettiPositions.removeAll() // حذف القصاصات الورقية
        showConfetti = false
    }
}

// Struct لتمثيل القصاصات الورقية
struct Confetti: Identifiable {
    let id = UUID()
    let position: CGPoint
    let color: Color
}

// Extension لتوليد ألوان عشوائية
extension Color {
    static func random() -> Color {
        return Color(
            red: Double.random(in: 0...1),
            green: Double.random(in: 0...1),
            blue: Double.random(in: 0...1)
        )
    }
}

// Preview
#Preview {
    CelebrationScreen(pixelArt: .constant(nil))
}
