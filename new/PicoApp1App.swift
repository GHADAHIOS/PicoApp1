//
//  PicoApp1App.swift
//  PicoApp1
//
//  Created by GHADAH ALENEZI on 14/06/1446 AH.
//

import SwiftUI
import SwiftData

@main
struct PicoApp1App: App {
    
    // تأكد من إضافة النموذج الخاص بك إلى Container
    @Environment(\.modelContext) private var modelContext: ModelContext
    
    var body: some Scene {
        WindowGroup {
            // التأكد من تفعيل الربط مع SwiftData
            SplashView()
                .modelContainer(for: PixelArt.self) // التأكد من أنه يستخدم
        }
    }
}
