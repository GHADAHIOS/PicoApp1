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
            VStack{
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
                  //  .padding(.leading, 45.0)
                    .overlay(
                        Text("Catogory")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                           // .padding(.leading, 45.0)
                            .offset(y: 70) // تحريك النص تحت الدائرة
                    )
                  //  Spacer(minLength:12)
                    
                    // صورة السحابة مع الشخصية
                    HStack {
                        Image("Pico")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 115, height: 115)
                            .offset(x: -0, y: 90)

                        ZStack {
                            Image("cloud")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 724.0, height: 326)
                                .offset(x: -80, y: -20)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.font1)
                                .multilineTextAlignment(.center)
                                //.padding(50)
                              //  .offset(x: -80, y: -20)
                            
                            Text( "Well done, genius! Keep going!")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.font1)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 80)
                                .offset(x: -70, y: -15)
                    } //end of zstack
                }
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
                        Text("Colorings")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.trailing, 45.0)
                            .offset(y: 70) // تحريك النص تحت الدائرة
                    )
                } //end of hstack
                
                .padding(.top, -100)
                
                
                //button
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.bhope) // لون رمادي شفاف
                        .frame(width: 398, height: 90) // حجم الدائرة
                        .offset(x: 4, y: 4)
                    
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.hope)                         .frame(width: 398, height:90)

                HStack {
                    
                    Image(.image3)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    HStack {
                        Text( "Save")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
            
                        
                        Image(systemName: "square.and.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                    }.padding(.horizontal, 80)
        
                    Image(.image3)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    }
                    
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.inspire) // لون رمادي شفاف
                        .frame(width: 398, height: 90) // حجم الدائرة
                        .offset(x: 4, y: 4)
                    
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.binspire)                         .frame(width: 398, height:90)

                HStack {
                    
                    Image(.image2)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    HStack {
                        Text( "Share")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
            
                        
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                    }.padding(.horizontal, 80)
        
                    Image(.image2)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    }
                    
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.bBrave) // لون رمادي شفاف
                        .frame(width: 398, height: 90) // حجم الدائرة
                        .offset(x: 4, y: 4)
                    
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.brave)                         .frame(width: 398, height:90)

                HStack {
                    
                    Image(.image1)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    HStack {
                        Text( "Delete")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
            
                        
                        Image(systemName: "trash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 2, y: 2)
                    }.padding(.horizontal, 80)
        
                    Image(.image1)
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                        .padding(.bottom, 50)
                    }
                    
                }

            } .padding(.bottom, 130)
           
            
        }
        
    }}

#Preview {
    CellarbrationScreen()
}
