//
//  onboardingView.swift
//  PicoApp1
//
//  Created by Alanoud Alamrani on 24/06/1446 AH.
//

import SwiftUI

struct onboardingView: View {
    var body: some View {
        VStack (spacing: -20) {
            
            Text("welcome to pico!")
               // .font(.largeTitle)
                .font(.system(size: 50))
                .fontWeight(.bold)
                .foregroundColor(Color("font1"))
            
            ZStack {
                Image("cloud")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 880.0, height: 326)
                    .scaleEffect(x: -1)
                    .offset(x: -20, y: -20)
                
                Text("Say the category you want to color")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.font1) // Text color
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .offset(x: -20, y: -20)
                
                Image("Pico")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 115, height: 115)
                    .padding(.leading, 910.0)
                    .padding(.top, 90.0)
            }
            
            Image(systemName: "mic.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 366, height: 350)
                .foregroundColor(.brave)
            
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.inspire)
                    .frame(width: 398, height: 90)
                    .offset(x: 4, y: 4)
                
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.binspire)
                    .frame(width: 398, height: 90)
                
                HStack {
                    Image(.image2)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    
                    HStack {
                        Text("Start Now")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                    }
                    .padding(.horizontal, 80)
                    
                    Image(.image2)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                }
            }
            .padding(.top, 40) // تعديل الإزاحة بين المايك والزر
        }
    }
}

#Preview {
    onboardingView()
}
