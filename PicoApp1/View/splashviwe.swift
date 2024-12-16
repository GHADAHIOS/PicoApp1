//
//  splashviwe.swift
//  PicoApp1
//
//  Created by Reema ALhudaian on 14/06/1446 AH.
//
import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var animationScale = 0.8
    @State private var animationOpacity = 0.5

    var body: some View {
        if isActive {
            // Navigate to Main Content
            CategoriesScreen()
        } else {
            ZStack {
                Color.BG // Background color
                    .ignoresSafeArea()

                VStack {
                    Image("Pico")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 288.04, height: 549.11)
                        .scaleEffect(animationScale)
                        .opacity(animationOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2).repeatForever(autoreverses: true)) {
                                animationScale = 1.0
                                animationOpacity = 1.0
                            }
                        }

                    Text("Pico")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                // Set a delay for the splash screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

