//
//  CellarbrationModel.swift
//  PicoApp1
//
//  Created by Alanoud Alamrani on 23/06/1446 AH.
//


import UIKit
import Photos

class CellarbrationModel {
    static let shared = CellarbrationModel()
    
    func saveImageToGallery(imageName: String, completion: @escaping (Bool) -> Void) {
        guard let image = UIImage(named: imageName) else {
            print("Image not found")
            completion(false)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("Image saved successfully")
                completion(true)
            } else {
                print("Permission denied")
                completion(false)
            }
        }
    }
}
