import SwiftUI

struct CategoriesScreen: View {
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)

    var body: some View {
        ZStack {
            // خلفية الصفحة
            Color.BG.edgesIgnoringSafeArea(.all)

            VStack {
                // القسم العلوي: السحابة + زر اللغة + الشخصية
                HStack {
                    // زر تغيير اللغة على اليسار
                    Button(action: {
                        isArabic.toggle() // تغيير حالة اللغة عند الضغط
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

                            // أيقونة "العالم"
                            Image(systemName: "globe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.leading, 25) // مسافة من اليسار
                    .padding(.top, -100)

                    Spacer()

                    // صورة السحابة مع الشخصية
                    HStack {
                        // صورة الشخصية
                        Image("Pico") // استبدل "character" باسم الصورة الخاصة بك
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

                            // النص على السحابة
                            Text("Say the category you would like to color") // النص داخل السحابة
                                .font(.title) // حجم الخط
                                .fontWeight(.semibold) // الخط عريض
                                .foregroundColor(.font1)
                                .multilineTextAlignment(.center) // محاذاة النص إلى الوسط
                                .padding(.horizontal, 50) // مسافة أفقية لضمان أن النص لا يخرج عن السحابة
                                .offset(x: -80, y: -20) // تعديل ارتفاع النص ليتوسط السحابة
                        }
                    }
                }
                .padding(.top, -30) // مسافة من الأعلى

                Spacer()

                // الكروت الثلاثة في المنتصف
                HStack(spacing: 20) {
                    // البطاقة الأولى
                    NavigationLink(destination: DrawingsScreen3()) {
                        VStack {
                            Text("Space")
                                .font(.largeTitle) // حجم الخط كبير
                                .fontWeight(.bold) // Bold
                                .foregroundColor(.white) // لون النص

                            Image("space")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 241.26, height: 213) // تعديل الحجم
                                .padding()
                        }
                        .frame(width: 340, height: 400) // أبعاد البطاقة
                        .background(Color.brave) // لون الخلفية
                        .cornerRadius(18) // زوايا مستديرة
                        .shadow(color: Color.brave.opacity(0.5), radius: 10, x: 0, y: 3) // ظل
                    }

                    // البطاقة الثانية
                    NavigationLink(destination: DrawingsScreen2()) {
                        VStack {
                            Text("Nature")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Image("food")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 241.26, height: 213)
                                .padding()
                        }
                        .frame(width: 340, height: 400)
                        .background(Color.hope)
                        .cornerRadius(18)
                        .shadow(color: Color.hope.opacity(0.5), radius: 10, x: 0, y: 3)
                    }

                    // البطاقة الثالثة
                    NavigationLink(destination: DrawingsScreen()) {
                        VStack {
                            Text("Animals")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Image("animal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 241.26, height: 213)
                                .padding()
                        }
                        .frame(width: 340, height: 400)
                        .background(Color.shine)
                        .cornerRadius(18)
                        .shadow(color: Color.shine.opacity(0.5), radius: 10, x: 0, y: 3)
                    }
                }
                .padding(.bottom, 78)

                Spacer()
            }
        }
    }
}

// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesScreen()
    }
}
