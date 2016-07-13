//
//  PSImagePickerController.swift
//  TestAndCheck_Swift
//
//  Created by prabhjot singh on 7/12/16.
//  Copyright © 2016 prabhjot singh. All rights reserved.
//

import UIKit

typealias ImageCompletionHandler = (image: UIImage?, imageController: UIImagePickerController?, success: Bool) -> Void

class PSImagePickerController: UIImagePickerController {
    
    var imageCompletionHandler: ImageCompletionHandler?
    
// MARK:- Public Methods
    
    /**
     method is used to open the Image Picker through Action sheet with three buttons Camera(will open the camera), Photo Library(will open the image library), Cancel (dismiss the picker)
     
     - parameter imagePickerHandler: closure object which sends back the image and success
     - parameter controller:         a view controller through which you call this method
     */
    
    func openImagePickerThroughActionSheet(imagePickerHandler: ImageCompletionHandler, controller: UIViewController) {
        
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
    func openImagePicker(imagePickerHandler: ImageCompletionHandler, controller: UIViewController) {
        
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
    private func setActionController(controller: UIViewController) {
        
        let sheet = UIAlertController(title: "Select Image From", message: nil, preferredStyle: .ActionSheet)
        sheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (alertAction) in
            self.loadCamera(controller)
        }))
        
        sheet.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (alertAction) in
            self.loadPhotoLibrary(controller)
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (alertAction) in
            
        }))
        
        controller.presentViewController(sheet, animated: true, completion: nil)
        
    }
    
    
    /**
     this method will load the photo library
     
     - parameter controller: a view controller through which you call this method
     */
    private func loadPhotoLibrary(controller: UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            self.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.showImagePicker(controller)
        } else {
            self.imageCompletionHandler!(image: nil, imageController: nil, success: false)
        }
    }
    
    /**
     this method will load the camera if its available
     
     - parameter controller: a view controller through which you call this method
     */
    private func loadCamera(controller: UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.sourceType = UIImagePickerControllerSourceType.Camera
            self.showImagePicker(controller)
        } else {
            self.imageCompletionHandler!(image: nil, imageController: nil, success: false)
        }
    }
    
    // Used to show the picker
    private func showImagePicker(controller: UIViewController) {
        controller.presentViewController(self, animated: true, completion: nil)
    }
}

// MARK:- Extension Of Picker Delegates

extension PSImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let tempImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageCompletionHandler!(image: tempImage, imageController: picker, success: true)
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageCompletionHandler!(image: originalImage, imageController: picker, success: true)
        } else {
            self.imageCompletionHandler!(image: nil, imageController: picker, success: false)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.imageCompletionHandler!(image: nil, imageController: picker, success: false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}