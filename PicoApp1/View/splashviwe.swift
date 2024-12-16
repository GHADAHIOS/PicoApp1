//
//  splashviwe.swift
//  PicoApp1
//
//  Created by Reema ALhudaian on 14/06/1446 AH.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
//                CategoryCardView(title: Pico, imageName: "Pico", color: "BG", shadowColor: true, shadowRadius: CGFloat)
            } else {
                Rectangle()
                    .background(Color.BG)
                Image("pico")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 288.04, height: 549.11)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
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
