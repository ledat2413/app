//
//  CategoryCollectionViewCell.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/6/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    
    func generateCell(_ category: Category) {
        lblName.text = category.name
        imgCategory.image = category.image
    }
}
