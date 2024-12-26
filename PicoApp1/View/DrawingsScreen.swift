import SwiftUI

struct DrawingsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: DrawingsViewModel
    //@StateObject private var pixelArtViewModel: PixelArtViewModel

    init(selectedCategory: String) {
        _viewModel = StateObject(wrappedValue: DrawingsViewModel(selectedCategory: selectedCategory))
        //_pixelArtViewModel = StateObject(wrappedValue: PixelArtViewModel()!)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        VStack {
                            Button(action: {
                                viewModel.navigateToCategories = true
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 77, height: 73)
                                        .offset(x: 2, y: 2)

                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 77, height: 73)
                                        .padding(.all, 5)

                                    Image(systemName: "circle.grid.2x2")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.white)
                                }
                            }
                            Text("Categories")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.top, 5)
                        }
                        .padding(.leading, 25)
                        .padding(.top, -100)

                        Spacer()

                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .scaleEffect(x: -1)
                                .offset(x: -80, y: 50)

                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 880.0, height: 326)
                                    .scaleEffect(x: -1)
                                    .offset(x: -80, y: -20)
                                Text("Say a drawing number to color")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                                    .offset(x: -80, y: -20)
                            }
                        }
                    }
                    .padding(.top, -30)

                    Spacer()

                    HStack(spacing: 10) {
                        let images = viewModel.categoryImages()

                        ForEach(1...4, id: \.self) { number in
                            Button(action: {
                                viewModel.playBubbleSound()
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    viewModel.clickedCard = number
                                }
                                viewModel.clickedCard = number
                                // Set the selected art number
                                viewModel.selectedArt = "\(number)"

                                viewModel.navigateToColoring = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(viewModel.categoryColor())
                                        .frame(width: 286, height: 350)
                                        .shadow(color: viewModel.categoryColor().opacity(0.2), radius: 5, x: 0, y: 2)
                                        .scaleEffect(viewModel.clickedCard == number ? 1.2 : 1.0)
                                    VStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color.white)
                                            .frame(width: 238.33, height: 266.13)
                                    }

                                    VStack {
                                        if number - 1 < images.count {
                                            Image(images[number - 1])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 208.33, height: 276.13)
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .shadow(radius: 5)
                                                .padding(.top, 5)
                                        }
                                    }

                                    VStack {
                                        Text("\(number)")
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 310)
                                    }
                                }
                            }
                            .opacity(viewModel.clickedCard == nil || viewModel.clickedCard == number ? 1.0 : 0.3)
                            .padding(.top, viewModel.clickedCard == number ? 0 : 50)
                            .zIndex(viewModel.clickedCard == number ? 1 : 0)
                        }
                    }
                    .padding(.bottom, 50)

                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $viewModel.navigateToCategories) {
                CategoriesScreen()
            }
            .navigationDestination(isPresented: $viewModel.navigateToColoring) {
               //PixelArtView()
                PixelArtDynmicView(selectedCategory: viewModel.selectedCategory, modelContext: modelContext)

            }
        }
        /*.environmentObject(pixelArtViewModel)*/ // Inject PixelArtViewModel into the environment

        .onAppear {
            viewModel.startListening()
        }
        
    }
}

// MARK: - Preview
struct DrawingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DrawingsScreen(selectedCategory: "Space")
    }
}
