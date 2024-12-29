import Foundation
import SwiftData
import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let color: Color
}

