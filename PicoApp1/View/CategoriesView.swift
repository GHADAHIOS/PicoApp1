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
                .font(.headline)
                .foregroundColor(.white)
            
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
    
    var body: some View {
        ZStack {
            Color.BG.edgesIgnoringSafeArea(.all) // خلفية الصفحة
            
            VStack {
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
