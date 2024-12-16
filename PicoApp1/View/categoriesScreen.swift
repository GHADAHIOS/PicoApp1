import SwiftUI

// MARK: - Category Card View (عرض بطاقة فئة واحدة)
struct CategoriesScreen: View { // تعديل اسم المكون ليبدأ بحرف كبير
    var title: String
    var imageName: String
    var color: Color
    var shadowColor: Color
    var shadowRadius: CGFloat
    
    var body: some View {
        VStack {
            // عنوان البطاقة
            Text(title)
                .font(.largeTitle) // حجم الخط كبير
                .fontWeight(.bold) // Bold
                .foregroundColor(.white) // لون النص
            
            // صورة داخل البطاقة
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 241.26, height: 213) // تعديل الحجم
                .padding()
        }
        .frame(width: 340, height: 400) // أبعاد البطاقة
        .background(color) // لون الخلفية
        .cornerRadius(18) // زوايا مستديرة
        .shadow(color: shadowColor.opacity(0.5), radius: shadowRadius, x: 0, y: 3) // ظل
    }
}

// MARK: - Categories Screen (الصفحة الرئيسية للفئات)
struct categoriesScreen: View {
    @State private var isArabic: Bool = true // حالة اللغة (عربي/إنجليزي)
    
    var body: some View {
        ZStack {
            // خلفية الصفحة
            Color.BG.edgesIgnoringSafeArea(.all)
            
            VStack {
                // القسم العلوي: السحابة + زر اللغة + الشخصية
                TopBarWithCharacter(isArabic: $isArabic)
                
                Spacer()
                
                // الكروت الثلاثة في المنتصف
                CategoriesRow()
                
                Spacer()
            }
        }
    }
}

// MARK: - Top Bar with Character (القسم العلوي: السحابة + الشخصية + زر اللغة)
struct TopBarWithCharacter: View {
    @Binding var isArabic: Bool
    
    var body: some View {
        HStack {
            // زر تغيير اللغة على اليسار
            LanguageToggleButton(isArabic: $isArabic)
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
                                       

                   // لون النص
                }
            }
        }
        .padding(.top, -30) // مسافة من الأعلى
    }
}

// MARK: - Language Toggle Button (زر تغيير اللغة)
struct LanguageToggleButton: View {
    @Binding var isArabic: Bool
    
    var body: some View {
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
    }
}

// MARK: - Categories Row (الصف الخاص بالكروت)
struct CategoriesRow: View {
    var body: some View {
        HStack(spacing: 20) {
            // البطاقة الأولى
            CategoryCardView(
                title: "Space",
                imageName: "space",
                color: Color.brave,
                shadowColor: Color.brave,
                shadowRadius: 10
            )
            
            // البطاقة الثانية
            CategoryCardView(
                title: "Nature",
                imageName: "food",
                color: Color.hope,
                shadowColor: Color.hope,
                shadowRadius: 10
            )
            
            // البطاقة الثالثة
            CategoryCardView(
                title: "Animals",
                imageName: "animal",
                color: Color.shine,
                shadowColor: Color.shine,
                shadowRadius: 10
            )
        }
        .padding(.bottom,78)
        // مسافة من الأسفل
    }
}

// MARK: - Preview
struct CategoriesScreen_Previews: PreviewProvider {
    static var previews: some View {
        categoriesScreen()
    }
}
