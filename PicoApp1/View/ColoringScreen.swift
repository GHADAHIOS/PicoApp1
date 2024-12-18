import SwiftUI

struct ColoringScreen: View {
    var body: some View {
        ZStack {
            Color(.BG)
                .ignoresSafeArea()

            HStack {
                VStack(spacing: 30) {
                    Button {
                        // Action for "Category" button
                    } label: {
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
                    }

                    
                    
                    Button {
                        // Action for "Undo" button
                    } label: {
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
                    }

                    Button {
                        // Action for "Redo" button
                    } label: {
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
                    }

                    Button {
                        // Action for "Reset" button
                    } label: {
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
                }
                .padding(.leading, 25)

                Spacer()
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
                          
                Button {
                    // Action for "Colorings" button
                } label: {
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
                }
                .padding(.trailing, 25)
                .padding(.bottom, 550)
                
                
                
            }

            HStack {
                VStack {
                    Button {
                        // Action for blue button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Blue")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for green button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Green")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for red button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Red")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for yellow button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Yellow")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for pink button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.pink)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Pink")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for orange button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Orange")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for brown button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.brown)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Brown")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for light blue button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.hope)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Light Blue")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }

                VStack {
                    Button {
                        // Action for purple button
                    } label: {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color.purple)
                                    .frame(width: 70, height: 70)

                                Circle()
                                    .stroke(Color.white, lineWidth: 6)
                                    .frame(width: 70, height: 70)
                                    .shadow(color: Color.black, radius: 1)
                            }
                            Text("Purple")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                        }
                    }
                }
            }
            .padding(.top, 650)
            .padding(.leading, 100)
        }
    }
}

#Preview {
    ColoringScreen()
}
