import SwiftUI
import Speech

struct CategoriesScreen: View {
    @State private var isArabic: Bool = false // Language toggle (English by default)
    @State private var isRecording = false
    @State private var audioEngine = AVAudioEngine()
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    @State private var selectedCategory: String? // Track the selected category
    @State private var navigateToDrawingsScreen = false
    @State private var clickedCard: String? = nil // Track the clicked card

    let voiceCommands = ["space", "food", "animals"]

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()

                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .offset(x: -80, y: 50)

                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 880.0, height: 326)
                                    .scaleEffect(x: -1)
                                    .offset(x: -80, y: -20)
                                Text("Say the category you want to color")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1) // Text color
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 50)
                                    .offset(x: -80, y: -20)
                            }
                        }
                    }
                    .padding(.top, -30)

                    Spacer()

                    HStack(spacing: 20) {
                        ForEach(["Space", "Food", "Animals"], id: \.self) { category in
                            Button(action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    clickedCard = category
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    clickedCard = nil
                                    selectedCategory = category
                                    navigateToDrawingsScreen = true
                                }
                            }) {
                                VStack(spacing: 15) {
                                    Image(category.lowercased())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180, height: 180)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)

                                    Text(category)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 340, height: 400)
                                .background(categoryColor(category)) // Dynamic background color
                                .cornerRadius(18)
                                .shadow(color: categoryColor(category).opacity(0.5), radius: 10, x: 0, y: 3)
                                .scaleEffect(clickedCard == category ? 1.2 : 1.0)
                                .opacity(clickedCard == nil || clickedCard == category ? 1.0 : 0.3)
                            }
                            .zIndex(clickedCard == category ? 1 : 0)
                        }
                    }
                    .padding(.bottom, 78)

                    Spacer()
                }
            }
            .onAppear {
                startListening()
            }
            .navigationDestination(isPresented: $navigateToDrawingsScreen) {
                DrawingsScreen(selectedCategory: selectedCategory ?? "")
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
        }
    }

    // Dynamic color for categories
    func categoryColor(_ category: String) -> Color {
        switch category {
        case "Space": return Color.shine
        case "Food": return Color.hope
        case "Animals": return Color.brave
        default: return Color.gray
        }
    }

    func startListening() { /* Add logic */ }
    func stopRecording() { /* Add logic */ }
    func handleVoiceCommand(_ command: String) { /* Add logic */ }
}

// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
