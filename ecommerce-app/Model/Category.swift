//
//  Category.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/6/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation
import UIKit

class Category{
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name:String, _imageName: String) {
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: Dictionary<String, Any>){
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: Download category from firebase
func downloadCategoryFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) { //closure @escaping
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments{(snapshot,error) in
        guard let snapshot = snapshot else { //keyword guard
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty{
            for categoryDictionary in snapshot.documents{
                categoryArray.append(Category(_dictionary: categoryDictionary.data() as Dictionary))
            }
        }
        completion(categoryArray)
    }
    
}

//MARK: Save category function
func saveCategoryToFirebase(_ category: Category){
    let id = UUID().uuidString
    category.id = id
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}

//MARK: Helpers
func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    return NSDictionary(objects: [category.id,category.name,category.imageName],
                        forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//use only one time
//func createCategorySet() {
//    let womenClothing  = Category(_name: "Women's Cloting & Accessories", _imageName: "womenCloth")
//    let footWaer = Category(_name: "Footwaer", _imageName: "footWaer")
//    let baby = Category(_name: "Baby", _imageName: "Baby")
//    let menClothing = Category(_name: "Men's Clothing & Accessories", _imageName: "menClo")
//    let health = Category(_name: "Health & Beauty", _imageName: "health")
//    let electronics = Category(_name: "Electronics", _imageName: "electronics")
//    let home = Category(_name: "Home & Kitchen", _imageName: "home")
//    let car = Category(_name: "Automobiles & Autocycles", _imageName: "car")
//    let luggage = Category(_name: "Luggage & bags", _imageName: "luggage")
//    let jewelery = Category(_name: "Jewelery", _imageName: "jewelery")
//    let hobby = Category(_name: "Hobby, Sport, Traveling", _imageName: "hobby")
//    let camera = Category(_name: "Camera & Optics", _imageName: "camera")
//    let industry = Category(_name: "Industry & Business", _imageName: "industry")
//    let pet = Category(_name: "Pet products", _imageName: "pet")
//    let garden = Category(_name: "Garden supplies", _imageName: "garden")
//
//    let arrayOfCategories = [womenClothing,footWaer,baby,menClothing,health,electronics,home,car,luggage,jewelery,hobby,camera,industry,pet,garden]
//
//    for category in arrayOfCategories{
//        saveCategoryToFirebase(category)
//    }
//}
//


