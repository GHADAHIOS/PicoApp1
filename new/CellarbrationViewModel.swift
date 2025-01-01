//
//  CellarbrationViewModel.swift
//  PicoApp1
//
//  Created by Alanoud Alamrani on 23/06/1446 AH.
//


import Foundation

class CellarbrationViewModel: ObservableObject {
    @Published var navigateToCategories = false
    @Published var navigateToColoring = false
    
    func saveImage() {
        CellarbrationModel.shared.saveImageToGallery(imageName: "Pico") { success in
            if success {
                print("Image saved successfully!")
            } else {
                print("Failed to save image.")
            }
        }
    }
}