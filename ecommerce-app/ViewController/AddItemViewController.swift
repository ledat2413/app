//
//  AddItemViewController.swift
//  ecommerce-app
//
//  Created by Le Dat on 8/7/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var txtTittle: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var tvDesc: UITextView!
    
    //MARK: Vars
    var category: Category!
    var itemImages:[UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width/2 - 30 , y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: (red: 0.99984) )
//    }
    
    //MARK: IBAction
    
    @IBAction func btnDone(_ sender: Any) {
        dismissKeyboard()
        if fieldsAreCompleted(){
            saveItemToFirebase()
        }else{
            print("Error all field are required")
            //TODO: Show error to the user
        }
    }
    @IBAction func btnCamera(_ sender: Any) {
        itemImages = []
        showImageGallery()
        
    }
    @IBAction func tapGesture(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    //MARK: Helper function

    private func fieldsAreCompleted() -> Bool{
        
        return (txtTittle.text != "" && txtPrice.text != "" && tvDesc.text != "" )
    }
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    private func popToTheView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Save item
    private func saveItemToFirebase(){
        let item = Item()
        item.id = UUID().uuidString
        item.name = txtTittle.text
        item.description = tvDesc.text
        item.categoryId = category.id
        item.price = Double(txtPrice.text!)
        
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                saveItemToFirestore(item)
                self.popToTheView()
            }
        }else{
            saveItemToFirestore(item)
            popToTheView()
        }
    }
    
    //MARK: Activity Indicator
    
    private func showLoadingIndicator(){
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.stopAnimating()
        }
    }
    
    private func hideloadingIndicator(){
        
        if activityIndicator != nil{
            activityIndicator!.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
    }
    
    //MARK: Show Gallery
    
    private func showImageGallery(){
        
        self.gallery  = GalleryController()
        self.gallery.delegate = self
        
        Config.Camera.imageLimit = 10
        Config.tabsToShow = [.imageTab,.cameraTab]
        
        self.present(self.gallery, animated: true, completion: nil)
        
        
    }
}

extension AddItemViewController: GalleryControllerDelegate{
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (imageResolve) in
                self.itemImages = imageResolve 
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
