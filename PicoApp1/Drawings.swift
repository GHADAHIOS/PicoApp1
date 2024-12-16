import SwiftUI

// Hex Color Extension for SwiftUI's Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}

struct Drawings: View {
    var body: some View {
        ScrollView(.horizontal) { // Enables horizontal scrolling if needed
            HStack(spacing: 10) { // Horizontal layout with spacing between cards
                ForEach(1...4, id: \.self) { index in // Creates 4 cards
                    Button(action: {
                        print("Card \(index) tapped!")
                    }) {
                        ZStack {
                            // Outer blue card
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color(hex: "#5BCAFF")) // Hex color for card background
                                .frame(width: 286, height: 350) // Outer card dimensions
                                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 5) // Shadow for card
                            
                            // Inner white rounded rectangle
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 238, height: 249) // Size of the white rounded rectangle
                                .offset(x: 0, y: 0) // Centered inside the blue card
                            
                            // Text at the bottom of each card
                            VStack {
                                Spacer()
                                Text("\(index)") // Display the number corresponding to each card
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center) // Center text inside the card
                                    .padding(.bottom,230)// Padding for spacing at the bottom
                                
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all) // Extend the content to the edges
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Drawings()
    }
}
