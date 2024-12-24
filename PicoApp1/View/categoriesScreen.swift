import SwiftUI

struct CategoriesScreen: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Header
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
                    
                    // Categories
                    HStack(spacing: 20) {
                        ForEach(viewModel.categories) { category in
                            Button(action: {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    viewModel.selectCategory(category.name)
                                }
                            }) {
                                VStack(spacing: 15) {
                                    Image(category.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180, height: 180)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)

                                    Text(category.name)
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 340, height: 400)
                                .background(category.color)
                                .cornerRadius(18)
                                .shadow(color: category.color.opacity(0.5), radius: 10, x: 0, y: 3)
                                .scaleEffect(viewModel.clickedCard == category.name ? 1.2 : 1.0)
                                .opacity(viewModel.clickedCard == nil || viewModel.clickedCard == category.name ? 1.0 : 0.3)
                            }
                            .zIndex(viewModel.clickedCard == category.name ? 1 : 0)
                        }
                    }
                    .padding(.bottom, 78)

                    Spacer()
                }
            }
            .onAppear {
                viewModel.startListening()
            }
            .navigationDestination(isPresented: $viewModel.navigateToDrawingsScreen) {
                DrawingsScreen(selectedCategory: viewModel.selectedCategory ?? "")
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
        }
    }
}

// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
