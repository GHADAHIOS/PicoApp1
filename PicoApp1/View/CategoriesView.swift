import SwiftUI

// عرض فئة واحدة
struct CategoryCardView: View {
    var title: String
    var imageName: String
    var color: Color
    var shadowColor: Color
    var shadowRadius: CGFloat
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle) // تغيير الخط إلى SF Arabic وحجم 50
            .fontWeight(.bold) // جعل النص Bold
            .foregroundColor(.white) // لون النص
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding()
        }
        .frame(width: 340, height: 400) // أبعاد المستطيل
        .background(color) // اللون
        .cornerRadius(18) // الزوايا الدائرية
        .shadow(color: shadowColor.opacity(0.5), radius: shadowRadius, x: 0, y: 3) // ظل مخصص
    }
}

// الصفحة الرئيسية لعرض جميع الفئات
struct CategoriesView: View {
    // استخدام ViewModel لتحميل البيانات
    @ObservedObject var viewModel = CategoriesViewModel()
    
    @State private var isArabic: Bool = true // حالة لتحديد اللغة
    
    var body: some View {
        ZStack {
            Color.BG.edgesIgnoringSafeArea(.all) // خلفية الصفحة
            
            VStack {
                // إضافة صورة قبل الفئات
                HStack {
                    Button(action: {
                        // تغيير اللغة عند الضغط على الزر
                        isArabic.toggle()
                    }) {
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
                            Image( systemName:"globe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white) // لون ا
                        }}
                    .padding(.leading, 20) // إضافة مساحة من اليسار
                    
                    Spacer()
                    
                    Image("cloud") // الصورة التي تظهر قبل الفئات
                        .resizable()
                        .scaledToFit()
                        .frame(width:724 , height: 126)
                    
                    Spacer()
                }
                
                Spacer()
                
                // عرض الفئات باستخدام ForEach
                HStack(spacing: 44) {
                    ForEach(viewModel.categories) { category in
                        CategoryCardView(
                            title: category.title,
                            imageName: category.imageName,
                            color: category.color,
                            shadowColor: category.shadowColor,
                            shadowRadius: category.shadowRadius
                        )
                    }
                }
                
                Spacer()
            }
            
        }
    }
}

// المعاينة
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
