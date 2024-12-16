import SwiftUI

struct DrawingsScreen: View {
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)
    var cardColor: Color // لون الكروت يتم استلامه عند التنقل من الصفحة السابقة

    var body: some View {
        ZStack {
            // خلفية الصفحة
            Color.BG.edgesIgnoringSafeArea(.all)

            VStack {
                // القسم العلوي: السحابة + زر اللغة + الشخصية
                HStack {
                    // زر تغيير اللغة
                    Button(action: {
                        isArabic.toggle() // تبديل حالة اللغة
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.inspire) // لون رمادي شفاف
                                .frame(width: 77, height: 73)
                                .offset(x: 2, y: 2)

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
                    .padding(.leading, 25)
                    .padding(.top, -100)

                    Spacer()

                    // السحابة مع الشخصية
                    HStack {
                        // الشخصية
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
                                .offset(x: -80, y: -20)
                            // النص في السحابة
                            Text("Say a drawing number to color")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.font1)
                                .multilineTextAlignment(.center)
                                .offset(x: -80, y: -20)
                        }
                    }
                }
                .padding(.top, -30)

                Spacer()

                // الكروت الكبيرة في منتصف الشاشة
                HStack(spacing: 10) {
                    // الكارد الأول
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(cardColor) // لون الكارت يعتمد على الفئة المختارة
                            .frame(width: 286, height: 350)
                            .shadow(color: cardColor.opacity(0.2), radius: 5, x: 0, y: 2)

                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 238.33, height: 256.13)

                            Text("4")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                    }

                    // الكارد الثاني
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(cardColor)
                            .frame(width: 286, height: 350)
                            .shadow(color: cardColor.opacity(0.2), radius: 5, x: 0, y: 2)

                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 238.33, height: 256.13)

                            Text("3")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                    }

                    // الكارد الثالث
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(cardColor)
                            .frame(width: 286, height: 350)
                            .shadow(color: cardColor.opacity(0.2), radius: 5, x: 0, y: 2)

                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 238.33, height: 256.13)

                            Text("2")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                    }

                    // الكارد الرابع
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(cardColor)
                            .frame(width: 286, height: 350)
                            .shadow(color: cardColor.opacity(0.2), radius: 5, x: 0, y: 2)

                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 238.33, height: 256.13)

                            Text("1")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 10)
                        }
                    }
                }
                .padding(.bottom, 50)

                Spacer()
            }
        }
    }
}

// MARK: - Preview
struct DrawingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        DrawingsScreen(cardColor: .yellow) // معاينة مع لون افتراضي
    }
}
