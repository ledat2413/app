//
//  Downloader.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/8/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemId: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    //escaping: we want keep memory when func has been excuted

    if Reachability.HasConnection(){
        var uploadImagesCount = 0
        var imageLinkArray: [String] = []
        var nameSuffix = 0
        
        for image in images{
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jgp"
            let imageData = image!.jpegData(compressionQuality: 0.5)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil{
                    
                    imageLinkArray.append(imageLink!)
                    
                    uploadImagesCount += 1
                    
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            
            nameSuffix += 1
        }
    }else{
        print("No Internet Connection")
    }
}


func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink: String?) -> Void) {
    
    var task: StorageUploadTask!
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        task.removeAllObservers()
        if error != nil {
            print("Error uploading image", error!.localizedDescription)
            completion(nil)
            return
        }
        storageRef.downloadURL { (url, error) in
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            completion(downloadUrl.absoluteString)
        }
    })
}
