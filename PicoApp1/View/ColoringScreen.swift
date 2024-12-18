import SwiftUI

struct ColoringScreen: View {
    var body: some View {
        ZStack {
            Color(.BG)
                .ignoresSafeArea()

            HStack {
               
                VStack(spacing: 30) {
                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.inspire)
                                .frame(width: 100, height: 100)
                                .offset(x: 3, y: 3)

                            Circle()
                                .fill(Color.binspire)
                                .frame(width: 100, height: 100)
                                .padding(5)

                            Image(systemName: "circle.grid.2x2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        Text("Category")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.inspire)
                                .frame(width: 100, height: 100)
                                .offset(x: 3, y: 3)

                            Circle()
                                .fill(Color.binspire)
                                .frame(width: 100, height: 100)
                                .padding(5)

                            Image(systemName: "arrowshape.turn.up.left.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        Text("Undo")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.inspire)
                                .frame(width: 100, height: 100)
                                .offset(x: 3, y: 3)

                            Circle()
                                .fill(Color.binspire)
                                .frame(width: 100, height: 100)
                                .padding(5)

                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        Text("Redo")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    VStack {
                        ZStack {
                            Circle()
                                .fill(Color.bBrave)
                                .frame(width: 100, height: 100)
                                .offset(x: 3, y: 3)

                            Circle()
                                .fill(Color.brave)
                                .frame(width: 100, height: 100)
                                .padding(5)

                            Image(systemName: "arrow.counterclockwise")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        Text("Reset")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                   
                }
                .padding(.leading, 25)

                Spacer()

                VStack {
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
                    Text("Colorings")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 550)
            }

            // صورة السحابة مع الشخصية
            ZStack {
                HStack {
                    Image("Pico")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 115, height: 115)
                        .offset(x: 10, y: 30)

                    ZStack {
                        Image("cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 780.0, height: 326)
                            .offset(x: -50, y: -80)

                        Text("Say the number to color it")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.font1)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                            .offset(x: -40, y: -80)
                    }
                }
                .padding(.top, -400)
                
                
                
            }
            
            
            HStack{
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 12)
                        .frame(width: 70, height: 70)
                            .shadow(color: Color.black, radius: 1)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 12)
                            .frame(width: 70, height: 70)
                            .shadow(color: Color.black, radius: 1)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
            
              
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 12)
                            .frame(width: 70, height: 70)
                    }
                    Text("Blue")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                

            }.padding(.top, 650)
        
        }
    }
}

#Preview {
    ColoringScreen()
}
