//
//  Item.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/7/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation
import UIKit

class Item{
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECTID] as? String
        categoryId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[KPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}


//MARK: Save items func
func saveItemToFirestore(_ item: Item) {
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}


//MARK: Helper functions
func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categoryId, item.name
        , item.description, item.price, item.imageLinks], forKeys: [kOBJECTID as NSCopying, kCATEGORYID as NSCopying, kNAME as NSCopying, kDESCRIPTION as NSCopying,KPRICE as NSCopying, kIMAGELINKS as NSCopying])
}
