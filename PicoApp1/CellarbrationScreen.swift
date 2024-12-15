//
//  CellarbrationScreen.swift
//  PicoApp1
//
//  Created by Alanoud Alamrani on 14/06/1446 AH.
//

import SwiftUI

struct CellarbrationScreen: View {
    var body: some View {
        ZStack{
            Color(.BG)
                .ignoresSafeArea()
            HStack{
                ZStack {
                    Circle()
                        .fill(Color.inspire) // لون رمادي شفاف
                        .frame(width: 100, height: 100) // حجم الدائرة
                        .offset(x: 3, y: 3) // تحريك الدائرة لأسفل ولليمين قليلًا
                    
                    Circle()
                        .fill(Color.binspire)
                        .frame(width: 100, height: 100) // نفس الحجم كالدائرة السفلية
                        .padding(.all, 5)
                    // الأيقونة داخل الدائرة
                    Image(systemName: "circle.grid.2x2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white) // لون الأيقونة
                }
                .padding(.leading, 45.0)
                .overlay(
                    Text("التلوين")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading, 45.0)
                        .offset(y: 70) // تحريك النص تحت الدائرة
                )
                Spacer(minLength:12)
                ZStack {
                    Circle()
                        .fill(Color.inspire) // لون رمادي شفاف
                        .frame(width: 100, height: 100) // حجم الدائرة
                        .offset(x: 3, y: 3)
                    
                    Circle()
                        .fill(Color.binspire)
                        .frame(width: 100, height: 100) // نفس الحجم كالدائرة السفلية
                    
                    // الأيقونة داخل الدائرة
                    Image(systemName: "paintbrush.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white) // لون الأيقونة
                    
                }
                .padding(.trailing, 45.0)
                .overlay(
                    Text("التلوين")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.trailing, 45.0)
                        .offset(y: 70) // تحريك النص تحت الدائرة
                )
            }
            
        }
        
    }}

#Preview {
    CellarbrationScreen()
}
