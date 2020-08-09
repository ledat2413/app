//
//  FirebaseCollectionReference.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/6/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String{
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
 
