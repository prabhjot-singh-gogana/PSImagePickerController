//
//  PSImagePickerController.swift
//  TestAndCheck_Swift
//
//  Created by prabhjot singh on 7/12/16.
//  Copyright © 2016 prabhjot singh. All rights reserved.
//

import UIKit

typealias ImageCompletionHandler = (_ image: UIImage?, _ imageController: UIImagePickerController?, _ success: Bool) -> Void

class PSImagePickerController: UIImagePickerController {
    
    var imageCompletionHandler: ImageCompletionHandler?
    
// MARK:- Public Methods
    
    /**
     method is used to open the Image Picker through Action sheet with three buttons Camera(will open the camera), Photo Library(will open the image library), Cancel (dismiss the picker)
     
     - parameter imagePickerHandler: closure object which sends back the image and success
     - parameter controller:         a view controller through which you call this method
     */
    
    func openImagePickerThroughActionSheet(_ imagePickerHandler: @escaping ImageCompletionHandler, controller: UIViewController) {
        
        if self.delegate == nil {
            self.delegate = self
        }
        self.imageCompletionHandler = imagePickerHandler
        
        self.setActionController(controller)
    }
    
    
    /**
     if you want to access image picker without action sheet then use this method
     
     - parameter imagePickerHandler: closure object which sends back the image and success
     - parameter controller:         a view controller through which you call this method
     */
    func openImagePicker(_ imagePickerHandler: @escaping ImageCompletionHandler, controller: UIViewController) {
        
        if self.delegate == nil {
            self.delegate = self
        }
        imageCompletionHandler = imagePickerHandler
        self.showImagePicker(controller)
    }
    
// MARK:- Private Other Methods
    
    /**
     used to set the action sheet with three buttons Camera, PhotoLibrary, Cancel
     
     - parameter controller: a view controller through which you call this method
     */
    fileprivate func setActionController(_ controller: UIViewController) {
        
        let sheet = UIAlertController(title: "Select Image From", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alertAction) in
            self.loadCamera(controller)
        }))
        
        sheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alertAction) in
            self.loadPhotoLibrary(controller)
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
            
        }))
        
        controller.present(sheet, animated: true, completion: nil)
        
    }
    
    
    /**
     this method will load the photo library
     
     - parameter controller: a view controller through which you call this method
     */
    fileprivate func loadPhotoLibrary(_ controller: UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.showImagePicker(controller)
        } else {
            self.imageCompletionHandler!(nil, nil, false)
        }
    }
    
    /**
     this method will load the camera if its available
     
     - parameter controller: a view controller through which you call this method
     */
    fileprivate func loadCamera(_ controller: UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.sourceType = UIImagePickerControllerSourceType.camera
            self.showImagePicker(controller)
        } else {
            self.imageCompletionHandler!(nil, nil, false)
        }
    }
    
    // Used to show the picker
    fileprivate func showImagePicker(_ controller: UIViewController) {
        controller.present(self, animated: true, completion: nil)
    }
}

// MARK:- Extension Of Picker Delegates

extension PSImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let tempImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageCompletionHandler!(tempImage, picker, true)
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageCompletionHandler!(originalImage, picker, true)
        } else {
            self.imageCompletionHandler!(nil, picker, false)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.imageCompletionHandler!(nil, picker, false)
        self.dismiss(animated: true, completion: nil)
    }

    
}
