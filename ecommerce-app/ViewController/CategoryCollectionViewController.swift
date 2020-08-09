//
//  CategoryCollectionViewController.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/6/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit


class CategoryCollectionViewController: UICollectionViewController {
    
    //MARK: Vars
    var categoryArray: [Category] = []
    private let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    private let itemsPerRow: CGFloat = 3
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell

        cell.generateCell(categoryArray[indexPath.row])
        
        return cell
    }
    
    //MARK: UICollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItemSeg", sender: categoryArray[indexPath.row])
    }
    
    //MARK: Download categories
    private func loadCategories(){
        downloadCategoryFromFirebase { (allCategories) in
            self.categoryArray = allCategories
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryToItemSeg" {
            let vc = segue.destination as! ItemsTableViewController
            vc.category = sender as! Category
        }
        
    }
}

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let withPerItem = availableWidth / itemsPerRow
        return CGSize(width: withPerItem, height: withPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
