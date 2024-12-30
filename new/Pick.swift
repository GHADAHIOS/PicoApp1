import SwiftUI
import Speech
import AVFoundation

struct Pick: View {
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    @State private var navigateToCategories = false
    @State private var navigateToColoring1 = false
    @State private var navigateToColoring2 = false
    @State private var navigateToColoring3 = false
    @State private var navigateToColoring4 = false

    @State private var clickedCard: Int? = nil // Track the clicked card for animation
    @State private var audioPlayer: AVAudioPlayer?
 
    let voiceCommands = ["one", "two", "three", "four", "categories"]
    let cardColors: [Color] = [.shine, .hope, .brave, .binspire] // Colors for the cards
    
  
    
    
  
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.BG.edgesIgnoringSafeArea(.all)

                VStack {
                    // Upper Section: Navigation Button & Character
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
                                Text("Say a drawing number to color")
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

                    // Cards Section
                    HStack(spacing: 10) {
                        ForEach(1...4, id: \.self) { number in
                            Button(action: {
                                playBubbleSound() // Play bubble sound
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    clickedCard = number
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    clickedCard = nil
                                    navigateToColoring(number: number)
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(cardColors[number - 1]) // Apply color based on card number
                                        .frame(width: 286, height: 350)
                                        .shadow(color: cardColors[number - 1].opacity(0.2), radius: 5, x: 0, y: 2)
                                        .scaleEffect(clickedCard == number ? 1.2 : 1.0) // Scale animation for selected card

                                    VStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 238.33, height: 256.13)

                                        Text("\(number)")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                    }
                                }
                            }
                            .opacity(clickedCard == nil || clickedCard == number ? 1.0 : 0.3) // Fade out unselected cards
                            .padding(.top, clickedCard == number ? 0 : 50) // Use padding to move the selected card up
                            .zIndex(clickedCard == number ? 1 : 0) //
                        }
                    }
                    .padding(.bottom, 50)

                    Spacer()
                }
            }
            .onAppear {
                startListening()
                playOnAppearSound() // Play sound when the view appears
            }
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

    func navigateToColoring(number: Int) {
        switch number {
        case 1: navigateToColoring1 = true
        case 2: navigateToColoring2 = true
        case 3: navigateToColoring3 = true
        case 4: navigateToColoring4 = true
        default: break
        }
    }

    func playBubbleSound() {
        guard let soundURL = Bundle.main.url(forResource: "bubble", withExtension: "m4a") else {
            print("Sound file not found!")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error)")
        }
    }

    func playOnAppearSound() {
        guard let soundURL = Bundle.main.url(forResource: "Hi", withExtension: "mp3") else {
            print("Sound file not found!")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error playing onAppear sound: \(error)")
        }
    }

    func startListening() {
        // Speech recognition setup (optional to implement)
    }

    func stopRecording() {
        // Stop recording functionality (optional to implement)
    }

    func handleVoiceCommand(_ command: String) {
        // Handle voice command logic (optional to implement)
    }
}

// MARK: - Preview
struct Pick_Previews: PreviewProvider {
    static var previews: some View {
        Pick()
    }
}
