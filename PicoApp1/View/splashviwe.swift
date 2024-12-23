import SwiftUI

struct SplashView: View {
    @State private var currentColorIndex = 0
    @State private var showBrush = true
    @State private var showRainbow = true
    @State private var showPico = false
    @State private var navigateToCategories = false
    @State private var picoScale: CGFloat = 0.1 // Initial scale for Pico animation
    @State private var picoOpacity: Double = 0.0 // Initial opacity for Pico animation
    @State private var displayedLetters: String = "" // Letters being typed

    let rainbowColors: [Color] = [
        .hope, .shine, .inspire, .hope, .inspire, .brave, .hope, .inspire
    ]

    let picoLetters: [(String, Color)] = [
        ("P", .hope),
        ("I", .shine),
        ("C", .inspire),
        ("O", .brave)
    ]

    var body: some View {
        if navigateToCategories {
            CategoriesScreen()
        } else {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)

                ZStack {
                    if showRainbow {
                        ForEach(0..<rainbowColors.count, id: \ .self) { index in
                            Circle()
                                .strokeBorder(lineWidth: 10)
                                .foregroundColor(rainbowColors[index])
                                .frame(width: CGFloat(100 + index * 20), height: CGFloat(100 + index * 20))
                                .opacity(currentColorIndex >= index ? 1.0 : 0.0)
                        }
                    }

                    if showPico {
                        VStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500, height: 500) // Larger logo size
                                .scaleEffect(picoScale)
                                .opacity(picoOpacity)
                                .animation(.easeInOut(duration: 1.0), value: picoScale)
                                .animation(.easeInOut(duration: 1.0), value: picoOpacity)

                            HStack(spacing: 10) {
                                ForEach(0..<displayedLetters.count, id: \ .self) { index in
                                    let letter = Array(displayedLetters)[index]
                                    let color = picoLetters.first(where: { $0.0 == String(letter) })?.1 ?? .black
                                    Text(String(letter))
                                        .font(.system(size: 40, weight: .bold)) // Larger font size
                                        .foregroundColor(color)
                                }
                            }
                            .animation(.easeInOut(duration: 0.2))
                        }
                    }
                }
            }
            .onAppear {
                startRainbowAnimation()
            }
        }
    }

    func startRainbowAnimation() {
        for index in 0..<rainbowColors.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                currentColorIndex = index

                if index == rainbowColors.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showBrush = false
                        withAnimation(.easeInOut(duration: 1.0)) {
                            showRainbow = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            showPico = true
                            picoScale = 1.0 // Animate Pico image from small to big
                            picoOpacity = 1.0 // Animate Pico fade-in
                            typePicoLetters() // Start typing letters
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                navigateToCategories = true
                            }
                        }
                    }
                }
            }
        }
    }

    func typePicoLetters() {
        for (index, letter) in picoLetters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                displayedLetters.append(letter.0)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
