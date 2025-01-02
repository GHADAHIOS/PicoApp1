import SwiftUI
import SwiftData

struct CellarbrationScreen: View {
    @StateObject private var viewModel = CellarbrationViewModel() // ربط بـ ViewModel
    // ربط بـ ViewModel

    @Query(sort: \PixelArt.id) var pixelArts: [PixelArt]  // Fetch all PixelArt objects sorted by id
    @Environment(\.modelContext) private var modelContext
    @Binding var pixelArt: PixelArt? // Binding to optional PixelArt
    
    var gridWidth: CGFloat = 400 // Fixed width for the whole grid
    var gridHeight: CGFloat = 400 // Fixed height for the whole grid
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.BG)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.navigateToCategories = true
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
                            viewModel.navigateToColoring = true
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
                        ZStack {
                            Image("cloud")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 700.0, height: 200)
                                .scaleEffect(x: -1)                    .offset(x: -30, y: -20)
                            Text("Well Done , Amazing art")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.font1) // Text color
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 50)
                                .offset(x: -30, y: -20)
                            
                            
                            
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                            
                                .frame(width: 115, height: 115)
                               // .scaleEffect(x: -1)
                               // .offset(x: -80, y: 50)
                                .padding(.leading, 710.0)
                                .padding(.top,90.0)
                            
                        }
                        .padding(.top, -30)
                    }
                    .padding(.top, -100)
                    
                
                    
                        // Display the selected PixelArt ID and dimensions
                        if let pixelArt = pixelArt {

                            // Calculate pixel size based on grid size
                            let pixelSize = min(gridWidth / CGFloat(pixelArt.width), gridHeight / CGFloat(pixelArt.height))
                            
                            // Render the Pixel Grid
                            VStack(spacing: 0) { // Remove spacing between rows
                                ForEach(0..<pixelArt.height, id: \.self) { row in
                                    HStack(spacing: 0) { // Remove spacing between columns
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
                            .frame(width: gridWidth, height: gridHeight) // Set the overall grid size
                            .padding(0) // Ensure no padding around the grid
                        } else {
                            Text("No Pixel Art found.") // When no PixelArt is selected
                                .font(.title)
                                .padding()
                        }
                        
                        // Display the list of PixelArt entries from the database (optional)
                        // Add your list of PixelArt items if needed.
                   
                    ///
                    HStack {
//                        Image("Pico")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 715, height: 215)
//                            .offset(x: -10, y: 40)
                        
                        
//                        VStack {
//                            // زر الحفظ
//                            Button(action: {
//                                viewModel.saveImage()
//                            }) {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 18)
//                                        .fill(Color.bhope)
//                                        .frame(width: 398, height: 90)
//                                        .offset(x: 4, y: 4)
//                                    
//                                    RoundedRectangle(cornerRadius: 18)
//                                        .fill(Color.hope)
//                                        .frame(width: 398, height: 90)
//                                    
//                                    HStack {
//                                        Image(.image3)
//                                            .resizable()
//                                            .frame(width: 25.0, height: 25.0)
//                                            .padding(.bottom, 50)
//                                        HStack {
//                                            Text("Save")
//                                                .font(.largeTitle)
//                                                .fontWeight(.bold)
//                                                .foregroundColor(Color.white)
//                                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
//                                            
//                                            Image(systemName: "square.and.arrow.down")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 50, height: 50)
//                                                .foregroundColor(.white)
//                                                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
//                                        }
//                                        .padding(.horizontal, 80)
//                                        
//                                        Image(.image3)
//                                            .resizable()
//                                            .frame(width: 25.0, height: 25.0)
//                                            .padding(.bottom, 50)
//                                    }
//                                }
//                            }
//                        }
                    }
                }
                .padding(.bottom, 130)
                
                // الانتقال إلى الصفحات باستخدام NavigationLink
                NavigationLink(
                    destination: Pick(),
                    isActive: $viewModel.navigateToCategories
                ) { EmptyView() }

//                NavigationLink(
//                    destination: ColoringScreen(),
//                    isActive: $viewModel.navigateToColoring
//                ) { EmptyView() }
            }
        }
    }
}


// Preview
#Preview {
//    CellarbrationScreen(pixelArt: "pixelArt")
}
