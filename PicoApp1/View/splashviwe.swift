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
        NavigationStack {
            if isActive {
                CategoriesScreen() // الانتقال إلى الشاشة الرئيسية
            } else {
                ZStack {
                    Color.BG // لون الخلفية
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
                    // تعيين مهلة زمنية قبل الانتقال إلى الشاشة الرئيسية
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            isActive = true
                        }
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

//struct SplashView_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashView()
//    }
//}

#Preview {
    SplashView()
}
