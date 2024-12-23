import SwiftUI

struct CategoriesScreen: View {
    @StateObject private var viewModel = CategoriesScreenViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.BG.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top Section
                    HStack {
                        VStack(spacing: 5) {
                            Button(action: viewModel.toggleLanguage) {
                                ZStack {
                                    Circle()
                                        .fill(Color.inspire)
                                        .frame(width: 77, height: 73)
                                        .padding(.trailing, 2)
                                        .padding(.bottom, 2)
                                    
                                    Circle()
                                        .fill(Color.binspire)
                                        .frame(width: 77, height: 73)
                                        .padding(.all, 5)
                                    
                                    Image(systemName: "globe")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.white)
                                }
                            }
                            Text("العربية")
                                .font(.headline)
                                .foregroundColor(.font1)
                        }
                        .padding(.leading, 25)
                        .padding(.top, 100)
                        
                        Spacer()
                        
                        HStack {
                            Image("Pico")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 115, height: 115)
                                .padding(.trailing, 80)
                                .padding(.top, 50)
                            
                            ZStack {
                                Image("cloud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 880.0, height: 326)
                                    .scaleEffect(x: -1)
                                    .padding(.trailing, 80)
                                    .padding(.bottom, 20)
                                
                                Text("Say the category you want to color")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.font1)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 50)
                                    .padding(.trailing, 80)
                                    .padding(.bottom, 20)
                            }
                        }
                    }
                    .padding(.top, -30)
                    
                    Spacer()
                    
                    // Categories Section
                    HStack(spacing: 20) {
                        NavigationLink(destination: DrawingsScreen(), isActive: $viewModel.navigateToSpace) {
                            categoryCard(title: "Space", imageName: "space", color: Color.brave)
                        }
                        
                        NavigationLink(destination: DrawingsScreen2(), isActive: $viewModel.navigateToNature) {
                            categoryCard(title: "Food", imageName: "food", color: Color.hope)
                        }
                        
                        NavigationLink(destination: DrawingsScreen(), isActive: $viewModel.navigateToAnimals) {
                            categoryCard(title: "Animals", imageName: "animal", color: Color.shine)
                        }
                    }
                    .padding(.bottom, 78)
                    
                    Spacer()
                }
            }
            .onAppear {
                viewModel.startListening()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
        }
    }
    
    // Helper function for category cards
    private func categoryCard(title: String, imageName: String, color: Color) -> some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 241.26, height: 213)
                .padding()
        }
        .frame(width: 340, height: 400)
        .background(color)
        .cornerRadius(18)
        .shadow(color: color.opacity(0.5), radius: 10, x: 0, y: 3)
    }
}

struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
//
//
//// MARK: - Preview
//struct CategoriesScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoriesScreen()
//    }
//}
