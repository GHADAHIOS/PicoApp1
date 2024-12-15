import SwiftUI

// تعريف بيانات الفئة
struct Category: Identifiable {
    let id = UUID() // معرف فريد
    let title: String // عنوان الفئة
    let imageName: String // اسم الصورة
    let color: Color // اللون الخاص بالفئة
    let shadowColor: Color // لون الظل
    let shadowRadius: CGFloat // قوة الظل
}
