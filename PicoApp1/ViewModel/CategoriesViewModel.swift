import SwiftUI

// ViewModel لإدارة الفئات
class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = [
        Category(title: "الفضاء", imageName: "planet", color: Color.brave, shadowColor: Color.brave, shadowRadius: 6),
        Category(title: "مأكولات", imageName: "burger", color: Color.hope, shadowColor: Color.hope, shadowRadius: 8),
        Category(title: "الحيوانات", imageName: "bird", color: Color.shine, shadowColor: Color.shine, shadowRadius: 10)
    ]
}
