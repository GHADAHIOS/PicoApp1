import SwiftUI

// تعريف البيانات لكل فئة
struct Category: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let color: Color
    let shadowColor: Color // لون الظل
    let shadowRadius: CGFloat // قوة الظل
}
